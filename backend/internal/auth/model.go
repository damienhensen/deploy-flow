package auth

import "time"

type RefreshToken struct {
	ID        int64      `db:"id"`
	UserID    int64      `db:"user_id"`
	TokenHash string     `db:"token_hash"`
	ExpiresAt time.Time  `db:"expires_at"`
	RevokedAt *time.Time `db:"revoked_at"`
	CreatedAt time.Time  `db:"created_at"`
	UpdatedAt time.Time  `db:"updated_at"`
}

type RefreshRequest struct {
	RefreshToken string `json:"refreshToken"`
}

type RefreshResponse struct {
	AccessToken  string `json:"accessToken"`
	RefreshToken string `json:"refreshToken"`
}
