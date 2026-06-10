package project

import (
	"errors"
	"fmt"
	"strings"

	"github.com/google/uuid"
)

type Service struct {
	repository *Repository
}

func NewService(repository *Repository) *Service {
	return &Service{repository: repository}
}

func (s *Service) FindAll() ([]Project, error) {
	return s.repository.FindAll()
}

func (s *Service) Create(repositoryURL, branch, provider, domain, subdomain string) (Project, error) {
	// if strings.TrimSpace(name) == "" {
	// 	return Project{}, errors.New("name is required")
	// }
	name := "Placeholder"

	if strings.TrimSpace(repositoryURL) == "" {
		return Project{}, errors.New("repository URL is required")
	}

	if strings.TrimSpace(branch) == "" {
		return Project{}, errors.New("branch is required")
	}

	if strings.TrimSpace(provider) == "" {
		return Project{}, errors.New("provider is required")
	}

	if strings.TrimSpace(domain) == "" {
		domain = "deployflow.app"
	}

	if strings.TrimSpace(subdomain) == "" {
		subDomainNamePart := strings.ToLower(name)
		subDomainNamePart = strings.ReplaceAll(subDomainNamePart, " ", "-")

		subdomain = fmt.Sprintf("%s-%s", subDomainNamePart, uuid.New().String()[:6])
	}

	project := Project{
		ID:            uuid.New().String(),
		Name:          name,
		RepositoryURL: repositoryURL,
		Branch:        branch,
		Provider:      provider,
		Domain:        domain,
		Subdomain:     subdomain,
	}

	if err := s.repository.Create(project); err != nil {
		return Project{}, err
	}

	return s.repository.FindByID(project.ID)

}
