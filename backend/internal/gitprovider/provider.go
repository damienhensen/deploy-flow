package gitprovider

import "context"

type Provider interface {
	ListRepositories(ctx context.Context, userID int64) ([]Repository, error)
	ListBranches(ctx context.Context, userID int64, owner, repo string) ([]Branch, error)
	CheckDeploymentConfig(ctx context.Context, userID int64, owner, repo, branch string) (*BranchDeploymentCheck, error)
}
