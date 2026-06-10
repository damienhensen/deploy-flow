-- +goose Up
CREATE TABLE
    users (
        id BIGINT AUTO_INCREMENT PRIMARY KEY,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );

CREATE TABLE
    connected_accounts (
        id BIGINT AUTO_INCREMENT PRIMARY KEY,
        user_id BIGINT NOT NULL,
        provider VARCHAR(50) NOT NULL,
        provider_user_id VARCHAR(255) NOT NULL,
        username VARCHAR(255) NOT NULL,
        avatar_url TEXT,
        access_token TEXT NOT NULL,
        refresh_token TEXT,
        expires_at TIMESTAMP NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        CONSTRAINT fk_connected_accounts_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        UNIQUE (provider, provider_user_id),
        UNIQUE (user_id, provider)
    );

-- +goose Down
DROP TABLE connected_accounts;
DROP TABLE users;