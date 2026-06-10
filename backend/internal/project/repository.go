package project

import "github.com/jmoiron/sqlx"

type Repository struct {
	db *sqlx.DB
}

func NewRepository(db *sqlx.DB) *Repository {
	return &Repository{db: db}
}

func (r *Repository) FindAll() ([]Project, error) {
	var projects []Project

	err := r.db.Select(&projects, `
		SELECT id, name, repository_url, branch, provider, created_at, updated_at
		FROM projects
		ORDER BY created_at DESC
	`)

	return projects, err
}

func (r *Repository) FindByID(id string) (Project, error) {
	var project Project

	err := r.db.Get(&project, `
		SELECT id, name, repository_url, branch, provider, created_at, updated_at
		FROM projects
		WHERE id = ?
	`, id)

	return project, err
}

func (r *Repository) Create(project Project) error {
	_, err := r.db.Exec("INSERT INTO projects (id, name, repository_url, branch, provider) VALUES (?, ?, ?, ?, ?)", project.ID, project.Name, project.RepositoryURL, project.Branch, project.Provider)

	return err
}
