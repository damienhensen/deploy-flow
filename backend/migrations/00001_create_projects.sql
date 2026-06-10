-- +goose Up
CREATE TABLE
    projects (
        id CHAR(36) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        repository_url VARCHAR(500) NOT NULL,
        branch VARCHAR(255) NOT NULL,
        provider VARCHAR(50) NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );

-- +goose Down
DROP TABLE projects;