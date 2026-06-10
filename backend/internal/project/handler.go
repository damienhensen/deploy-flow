package project

import (
	"encoding/json"
	"net/http"
)

type Handler struct {
	service *Service
}

func NewHandler(service *Service) *Handler {
	return &Handler{service: service}
}

type CreateProjectRequest struct {
	Name          string `json:"name"`
	RepositoryURL string `json:"repository_url"`
	Branch        string `json:"branch"`
	Provider      string `json:"provider"`
}

func (h *Handler) FindAll(w http.ResponseWriter, r *http.Request) {
	projects, err := h.service.FindAll()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(projects)
}

func (h *Handler) Create(w http.ResponseWriter, r *http.Request) {
	var request CreateProjectRequest

	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		http.Error(w, "invalid request body", http.StatusBadRequest)
		return
	}

	if request.Name == "" || request.RepositoryURL == "" || request.Branch == "" || request.Provider == "" {
		http.Error(w, "missing required fields", http.StatusBadRequest)
		return
	}

	project, err := h.service.Create(
		request.Name,
		request.RepositoryURL,
		request.Branch,
		request.Provider,
	)

	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(project)
}
