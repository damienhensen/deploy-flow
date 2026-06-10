package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/damienhensen/deploy-flow/backend/graph"
	"github.com/damienhensen/deploy-flow/backend/internal/auth"
	"github.com/damienhensen/deploy-flow/backend/internal/config"
	"github.com/damienhensen/deploy-flow/backend/internal/database"
	"github.com/damienhensen/deploy-flow/backend/internal/handlers"
	"github.com/damienhensen/deploy-flow/backend/internal/middelware"
	"github.com/damienhensen/deploy-flow/backend/internal/project"
	"github.com/damienhensen/deploy-flow/backend/internal/user"
)

func main() {
	cfg := config.Load()

	db, err := database.Connect(cfg.DatabaseURL)
	if err != nil {
		log.Fatal(err)
	}

	defer db.Close()

	// Auth stuff
	authService := auth.NewService(os.Getenv("JWT_SECRET"))
	authRepository := auth.NewRepository(db)

	// GitHub OAuth
	githubAuthHandler := handlers.NewGitHubAuthHandler(
		os.Getenv("GITHUB_CLIENT_ID"),
		os.Getenv("GITHUB_CLIENT_SECRET"),
		os.Getenv("GITHUB_REDIRECT_URL"),
		user.NewRepository(db),
		authService,
		authRepository,
	)

	http.HandleFunc("/auth/github/login", githubAuthHandler.Login)
	http.HandleFunc("/auth/github/callback", githubAuthHandler.Callback)

	// Refresh tokens
	authHandler := handlers.NewAuthHandler(
		authService,
		authRepository,
	)

	http.HandleFunc("/auth/refresh", authHandler.Refresh)

	// Status
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "DeployFlow backend is running")
	})

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		if err := db.Ping(); err != nil {
			http.Error(w, "database unavailable", http.StatusServiceUnavailable)
		}

		fmt.Fprintln(w, "ok")
	})

	// GraphQL
	projectRepository := project.NewRepository(db)
	projectService := project.NewService(projectRepository)

	grapqlHandler := handler.NewDefaultServer(graph.NewExecutableSchema(
		graph.Config{
			Resolvers: &graph.Resolver{
				ProjectService: projectService,
			},
		},
	))

	http.Handle("/graphql", middelware.RequireAuth(authService, grapqlHandler))

	log.Println("Starting DeployFlow backend on :" + cfg.Port)

	if err := http.ListenAndServe(":"+cfg.Port, nil); err != nil {
		log.Fatal(err)
	}
}
