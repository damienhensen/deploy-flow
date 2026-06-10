package user

import (
	"database/sql"

	"github.com/damienhensen/deploy-flow/backend/internal/database"
	"github.com/jmoiron/sqlx"
)

type Repository struct {
	database.Repository
}

func NewRepository(db *sqlx.DB) *Repository {
	return &Repository{Repository: *database.NewRepository(db)}
}

type FoundAccount struct {
	ID     int64 `db:"id"`
	UserID int64 `db:"user_id"`
}

func (r *Repository) FindOrCreateUserByProviderAccount(
	provider string,
	providerUserID string,
	username string,
	avatarURL string,
	accessToken string,
) (User, error) {
	found, err := r.findConnectedAccount(provider, providerUserID)

	if err == nil {
		return r.updateConnectedAccountAndGetUser(
			found,
			username,
			avatarURL,
			accessToken,
		)
	}

	if err != sql.ErrNoRows {
		return User{}, err
	}

	return r.createUserWithConnectedAccount(
		provider,
		providerUserID,
		username,
		avatarURL,
		accessToken,
	)
}

func (r *Repository) findConnectedAccount(
	provider string,
	providerUserID string,
) (FoundAccount, error) {
	var found FoundAccount

	err := r.DB.Get(&found, `
		SELECT id, user_id
		FROM connected_accounts
		WHERE provider = ? AND provider_user_id = ?
	`, provider, providerUserID)

	return found, err
}

func (r *Repository) updateConnectedAccountAndGetUser(
	found FoundAccount,
	username string,
	avatarURL string,
	accessToken string,
) (User, error) {
	err := r.updateConnectedAccount(
		found.ID,
		username,
		avatarURL,
		accessToken,
	)
	if err != nil {
		return User{}, err
	}

	return r.findUserByID(found.UserID)
}

func (r *Repository) updateConnectedAccount(
	accountID int64,
	username string,
	avatarURL string,
	accessToken string,
) error {
	_, err := r.DB.Exec(`
		UPDATE connected_accounts
		SET username = ?, avatar_url = ?, access_token = ?
		WHERE id = ?
	`, username, avatarURL, accessToken, accountID)

	return err
}

func (r *Repository) createUserWithConnectedAccount(
	provider string,
	providerUserID string,
	username string,
	avatarURL string,
	accessToken string,
) (User, error) {
	tx, err := r.DB.Beginx()
	if err != nil {
		return User{}, err
	}
	defer tx.Rollback()

	userID, err := r.insertUser(tx)
	if err != nil {
		return User{}, err
	}

	err = r.insertConnectedAccount(
		tx,
		userID,
		provider,
		providerUserID,
		username,
		avatarURL,
		accessToken,
	)
	if err != nil {
		return User{}, err
	}

	if err := tx.Commit(); err != nil {
		return User{}, err
	}

	return r.findUserByID(userID)
}

func (r *Repository) insertUser(tx *sqlx.Tx) (int64, error) {
	result, err := tx.Exec(`
		INSERT INTO users () VALUES ()
	`)
	if err != nil {
		return 0, err
	}

	return result.LastInsertId()
}

func (r *Repository) insertConnectedAccount(
	tx *sqlx.Tx,
	userID int64,
	provider string,
	providerUserID string,
	username string,
	avatarURL string,
	accessToken string,
) error {
	_, err := tx.Exec(`
		INSERT INTO connected_accounts (
			user_id,
			provider,
			provider_user_id,
			username,
			avatar_url,
			access_token
		) VALUES (?, ?, ?, ?, ?, ?)
	`, userID, provider, providerUserID, username, avatarURL, accessToken)

	return err
}

func (r *Repository) findUserByID(userID int64) (User, error) {
	var user User

	err := r.DB.Get(&user, `
		SELECT id, created_at, updated_at
		FROM users
		WHERE id = ?
	`, userID)

	return user, err
}
