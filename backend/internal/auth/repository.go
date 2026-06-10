package auth

import (
	"errors"
	"time"

	"github.com/damienhensen/deploy-flow/backend/internal/database"
	"github.com/golang-jwt/jwt/v5"
	"github.com/jmoiron/sqlx"
)

type Repository struct {
	database.Repository
}

func NewRepository(db *sqlx.DB) *Repository {
	return &Repository{Repository: *database.NewRepository(db)}
}

func (r *Repository) FindRefreshTokenByHash(tokenHash string) (RefreshToken, error) {
	var token RefreshToken

	err := r.DB.Get(&token, `
		SELECT id, user_id, token_hash, expires_at, revoked_at, created_at, updated_at
		FROM refresh_tokens
		WHERE token_hash = ?
		AND revoked_at IS NULL
		AND expires_at > NOW()
	`, tokenHash)

	return token, err
}

func (r *Repository) RevokeRefreshToken(id int64) error {
	_, err := r.DB.Exec(`
		UPDATE refresh_tokens
		SET revoked_at = NOW()
		WHERE id = ?
	`, id)

	return err
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

func (s *Service) ValidateAccessToken(tokenString string) (*Claims, error) {
	token, err := jwt.ParseWithClaims(
		tokenString,
		&Claims{},
		func(token *jwt.Token) (any, error) {
			return []byte(s.JWTSecret), nil
		},
	)

	if err != nil {
		return nil, err
	}

	claims, ok := token.Claims.(*Claims)
	if !ok || !token.Valid {
		return nil, errors.New("invalid token")
	}

	return claims, nil
}
