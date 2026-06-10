package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/damienhensen/deploy-flow/backend/graph"
	"github.com/damienhensen/deploy-flow/backend/internal/config"
	"github.com/damienhensen/deploy-flow/backend/internal/database"
	"github.com/damienhensen/deploy-flow/backend/internal/project"
)

func main() {
	cfg := config.Load()

	db, err := database.Connect(cfg.DatabaseURL)
	if err != nil {
		log.Fatal(err)
	}

	defer db.Close()

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "DeployFlow backend is running")
	})

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		if err := db.Ping(); err != nil {
			http.Error(w, "database unavailable", http.StatusServiceUnavailable)
		}

		fmt.Fprintln(w, "ok")
	})

	// Wire Project Service
	projectRepository := project.NewRepository(db)
	projectService := project.NewService(projectRepository)

	srv := handler.NewDefaultServer(graph.NewExecutableSchema(
		graph.Config{
			Resolvers: &graph.Resolver{
				ProjectService: projectService,
			},
		},
	))

	http.Handle("/graphql", srv)

	log.Println("Starting DeployFlow backend on :" + cfg.Port)

	if err := http.ListenAndServe(":"+cfg.Port, nil); err != nil {
		log.Fatal(err)
	}
}
