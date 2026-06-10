package database

import (
	"github.com/jmoiron/sqlx"

	_ "github.com/go-sql-driver/mysql"
)

func Connect(databaseURL string) (*sqlx.DB, error) {
	db, err := sqlx.Connect("mysql", databaseURL)
	if err != nil {
		return nil, err
	}

	return db, nil
}
