package project

import (
	"github.com/damienhensen/deploy-flow/backend/internal/database"
	"github.com/jmoiron/sqlx"
)

type Repository struct {
	database.Repository
}

func NewRepository(db *sqlx.DB) *Repository {
	return &Repository{Repository: *database.NewRepository(db)}
}

func (r *Repository) FindAll() ([]Project, error) {
	var projects []Project

	err := r.DB.Select(&projects, `
		SELECT id, name, repository_url, branch, provider, domain, subdomain, created_at, updated_at
		FROM projects
		ORDER BY created_at DESC
	`)

	return projects, err
}

func (r *Repository) FindByID(id string) (Project, error) {
	var project Project

	err := r.DB.Get(&project, `
		SELECT id, name, repository_url, branch, provider, domain, subdomain, created_at, updated_at
		FROM projects
		WHERE id = ?
	`, id)

	return project, err
}

func (r *Repository) Create(project Project) error {
	_, err := r.DB.Exec(
		"INSERT INTO projects (id, name, repository_url, branch, provider, domain, subdomain) VALUES (?, ?, ?, ?, ?, ?, ?)",
		project.ID, project.Name, project.RepositoryURL, project.Branch, project.Provider, project.Domain, project.Subdomain,
	)

	return err
}
