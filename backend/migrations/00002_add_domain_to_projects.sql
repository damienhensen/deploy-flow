-- +goose Up
ALTER TABLE projects
ADD COLUMN domain VARCHAR(500) NOT NULL DEFAULT 'deployflow.app',
ADD COLUMN subdomain VARCHAR(500) NOT NULL DEFAULT '';

-- +goose Down
ALTER TABLE projects
DROP COLUMN domain,
DROP COLUMN subdomain;