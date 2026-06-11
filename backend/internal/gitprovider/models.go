package gitprovider

import "time"

type Repository struct {
	ID            string
	Name          string
	FullName      string
	Owner         string
	URL           string
	DefaultBranch string
	UpdatedAt     time.Time
	Private       bool
}

type Branch struct {
	Name                 string
	UpdatedAt            time.Time
	LastCommitAuthorName *string
	LastCommitSha        string
}

type BranchDeploymentCheck struct {
	HasDockerCompose bool
	ComposeFilePath  *string
}
