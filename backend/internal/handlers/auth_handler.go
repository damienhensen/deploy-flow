package handlers

import (
	"encoding/json"
	"net/http"

	"github.com/damienhensen/deploy-flow/backend/internal/auth"
)

type AuthHandler struct {
	AuthService    *auth.Service
	AuthRepository *auth.Repository
}

func NewAuthHandler(
	authService *auth.Service,
	authRepository *auth.Repository,
) *AuthHandler {
	return &AuthHandler{
		AuthService:    authService,
		AuthRepository: authRepository,
	}
}

func (h *AuthHandler) Refresh(w http.ResponseWriter, r *http.Request) {
	var request auth.RefreshRequest

	if err := json.NewDecoder(r.Body).Decode(&request); err != nil {
		http.Error(w, "invalid request body", http.StatusBadRequest)
		return
	}

	if request.RefreshToken == "" {
		http.Error(w, "missing refresh token", http.StatusBadRequest)
		return
	}

	storedToken, err := h.AuthRepository.FindRefreshTokenByHash(request.RefreshToken)
	if err != nil {
		http.Error(w, "invalid refresh token", http.StatusUnauthorized)
		return
	}

	session, err := h.rotateRefreshToken(storedToken)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	writeJSON(w, http.StatusOK, session)
}

func (h *AuthHandler) rotateRefreshToken(oldToken auth.RefreshToken) (auth.RefreshResponse, error) {
	newAccessToken, err := h.AuthService.GenerateAccessToken(oldToken.UserID)
	if err != nil {
		return auth.RefreshResponse{}, err
	}

	newRefreshToken, err := h.AuthService.GenerateRefreshToken()
	if err != nil {
		return auth.RefreshResponse{}, err
	}

	newRefreshTokenHash := h.AuthService.HashRefreshToken(newRefreshToken)

	if err := h.AuthRepository.RevokeRefreshToken(oldToken.ID); err != nil {
		return auth.RefreshResponse{}, err
	}

	if err := h.AuthRepository.CreateRefreshToken(
		oldToken.UserID,
		newRefreshTokenHash,
		h.AuthService.RefreshTokenExpiresAt(),
	); err != nil {
		return auth.RefreshResponse{}, err
	}

	return auth.RefreshResponse{
		AccessToken:  newAccessToken,
		RefreshToken: newRefreshToken,
	}, nil
}

func writeJSON(w http.ResponseWriter, status int, data any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(data)
}
