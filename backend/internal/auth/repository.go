package auth

import (
	"time"

	"github.com/alexedwards/argon2id"
	"github.com/damienhensen/deploy-flow/backend/internal/database"
	"github.com/jmoiron/sqlx"
)

type Repository struct {
	database.Repository
}

func NewRepository(db *sqlx.DB) *Repository {
	return &Repository{Repository: *database.NewRepository(db)}
}

func (r *Repository) CreateRefreshToken(userID int64, tokenHash string, expiresAt time.Time) error {
	_, err := r.DB.Exec(`
		INSERT INTO refresh_tokens (
			user_id,
			token_hash,
			expires_at
		) VALUES (?, ?, ?)`,
		userID, tokenHash, expiresAt)

	return err
}

func (s *Service) HashRefreshToken(refreshToken string) (string, error) {
	hash, err := argon2id.CreateHash(refreshToken, argon2id.DefaultParams)
	if err != nil {
		return "", err
	}

	return hash, nil
}
