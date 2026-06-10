-- +goose Up
ALTER TABLE projects
ADD COLUMN user_id BIGINT NOT NULL;

-- +goose Down
ALTER TABLE projects
DROP COLUMN user_id;