package project

import "github.com/google/uuid"

type Service struct {
	repository *Repository
}

func NewService(repository *Repository) *Service {
	return &Service{repository: repository}
}

func (s *Service) FindAll() ([]Project, error) {
	return s.repository.FindAll()
}

func (s *Service) Create(name, repositoryURL, branch, provider string) (Project, error) {
	project := Project{
		ID:            uuid.New().String(),
		Name:          name,
		RepositoryURL: repositoryURL,
		Branch:        branch,
		Provider:      provider,
	}

	if err := s.repository.Create(project); err != nil {
		return Project{}, err
	}

	return s.repository.FindByID(project.ID)

}
