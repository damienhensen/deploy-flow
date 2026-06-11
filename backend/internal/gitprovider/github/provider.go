package github

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/damienhensen/deploy-flow/backend/internal/gitprovider"
	"github.com/damienhensen/deploy-flow/backend/internal/user"
)

type Provider struct {
	httpClient     *http.Client
	userRepository *user.Repository
}

func NewProvider(userRepository *user.Repository) *Provider {
	return &Provider{
		httpClient:     http.DefaultClient,
		userRepository: userRepository,
	}
}

func (p *Provider) doGitHubRequest(
	ctx context.Context,
	userID int64,
	method string,
	url string,
	target any,
) error {
	token, err := p.userRepository.GetAccessToken(userID, "github")
	if err != nil {
		return err
	}

	req, err := http.NewRequestWithContext(ctx, method, url, nil)
	if err != nil {
		return err
	}

	req.Header.Set("Authorization", "Bearer "+token)
	req.Header.Set("Accept", "application/vnd.github+json")
	req.Header.Set("X-GitHub-Api-Version", "2022-11-28")

	res, err := p.httpClient.Do(req)
	if err != nil {
		return err
	}

	defer res.Body.Close()

	if res.StatusCode < 200 || res.StatusCode >= 300 {
		return fmt.Errorf("github request failed: %s", res.Status)
	}

	return json.NewDecoder(res.Body).Decode(target)
}

func (p *Provider) ListRepositories(ctx context.Context, userID int64) ([]gitprovider.Repository, error) {
	var response []githubRepoResponse

	err := p.doGitHubRequest(
		ctx,
		userID,
		http.MethodGet,
		"https://api.github.com/user/repos?sort=updated&per_page=100",
		&response,
	)

	if err != nil {
		return nil, err
	}

	repos := make([]gitprovider.Repository, 0, len(response))

	for _, repo := range response {
		repos = append(repos, gitprovider.Repository{
			ID:            fmt.Sprintf("%d", repo.ID),
			Name:          repo.Name,
			FullName:      repo.FullName,
			URL:           repo.HTMLURL,
			Owner:         repo.Owner.Login,
			DefaultBranch: repo.DefaultBranch,
			UpdatedAt:     repo.UpdatedAt,
			Private:       repo.Private,
		})
	}

	return repos, nil
}

func (p *Provider) ListBranches(ctx context.Context, userID int64, owner, repo string) ([]gitprovider.Branch, error) {
	var branchResponses []githubBranchResponse

	url := fmt.Sprintf("https://api.github.com/repos/%s/%s/branches?per_page=100", owner, repo)

	err := p.doGitHubRequest(ctx, userID, http.MethodGet, url, &branchResponses)
	if err != nil {
		return nil, err
	}

	branches := make([]gitprovider.Branch, 0, len(branchResponses))

	for _, branch := range branchResponses {
		var commit githubCommitResponse

		commitUrl := fmt.Sprintf(
			"https://api.github.com/repos/%s/%s/commits/%s",
			owner,
			repo,
			branch.Name,
		)

		err := p.doGitHubRequest(ctx, userID, http.MethodGet, commitUrl, &commit)
		if err != nil {
			return nil, err
		}

		authorName := commit.Commit.Author.Name

		branches = append(branches, gitprovider.Branch{
			Name:                 branch.Name,
			LastCommitSha:        commit.Sha,
			LastCommitAuthorName: &authorName,
			UpdatedAt:            commit.Commit.Author.Date,
		})
	}

	return branches, nil
}

func (p *Provider) CheckDeploymentConfig(
	ctx context.Context,
	userID int64,
	owner string,
	repo string,
	branch string,
) (*gitprovider.BranchDeploymentCheck, error) {
	possibleFiles := []string{
		"docker-compose.yml",
		"docker-compose.yaml",
		"docker-compose.prod.yml",
		"docker-compose.prod.yaml",
		"docker-compose-prod.yml",
		"docker-compose-prod.yaml",
		"compose.yml",
		"compose.yaml",
		"compose.prod.yml",
		"compose.prod.yaml",
		"compose-prod.yml",
		"compose-prod.yaml",
	}

	for _, file := range possibleFiles {
		var result map[string]any

		url := fmt.Sprintf(
			"https://api.github.com/repos/%s/%s/contents/%s?ref=%s",
			owner,
			repo,
			file,
			branch,
		)

		err := p.doGitHubRequest(ctx, userID, http.MethodGet, url, &result)
		if err == nil {
			return &gitprovider.BranchDeploymentCheck{
				HasDockerCompose: true,
				ComposeFilePath:  &file,
			}, nil
		}
	}

	return &gitprovider.BranchDeploymentCheck{
		HasDockerCompose: false,
		ComposeFilePath:  nil,
	}, nil
}
