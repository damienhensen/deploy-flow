package user

import "time"

type User struct {
	ID        int64     `db:"id"`
	CreatedAt time.Time `db:"created_at"`
	UpdatedAt time.Time `db:"updated_at"`
}

type ConnectedAccount struct {
	ID             int64     `db:"id"`
	UserID         int64     `db:"user_id"`
	Provider       string    `db:"provider"`
	ProviderUserID string    `db:"provider_user_id"`
	Username       string    `db:"username"`
	AvatarURL      *string   `db:"avatar_url"`
	AccessToken    string    `db:"access_token"`
	RefreshToken   *string   `db:"refresh_token"`
	ExpiresAt      time.Time `db:"expired_at"`
	CreatedAt      time.Time `db:"created_at"`
	UpdatedAt      time.Time `db:"updated_at"`
}
