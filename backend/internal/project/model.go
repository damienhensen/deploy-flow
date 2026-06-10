package project

import "time"

type Project struct {
	ID            string    `db:"id"`
	Name          string    `db:"name"`
	RepositoryURL string    `db:"repository_url"`
	Branch        string    `db:"branch"`
	Provider      string    `db:"provider"`
	CreatedAt     time.Time `db:"created_at"`
	UpdatedAt     time.Time `db:"updated_at"`
}
