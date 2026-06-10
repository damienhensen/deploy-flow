package project

import "time"

type Project struct {
	ID            string    `db:"id"`
	UserID        int64     `db:"user_id"`
	Name          string    `db:"name"`
	RepositoryURL string    `db:"repository_url"`
	Branch        string    `db:"branch"`
	Provider      string    `db:"provider"`
	Domain        string    `db:"domain"`
	Subdomain     string    `db:"subdomain"`
	CreatedAt     time.Time `db:"created_at"`
	UpdatedAt     time.Time `db:"updated_at"`
}
