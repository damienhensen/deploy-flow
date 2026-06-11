package graph

import (
	"github.com/damienhensen/deploy-flow/backend/internal/gitprovider"
	"github.com/damienhensen/deploy-flow/backend/internal/project"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require
// here.

type Resolver struct {
	ProjectService *project.Service
	GitProviders   map[string]gitprovider.Provider
}
