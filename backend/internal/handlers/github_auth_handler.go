package handlers

import (
	"crypto/rand"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strconv"
	"strings"

	"github.com/damienhensen/deploy-flow/backend/internal/auth"
	"github.com/damienhensen/deploy-flow/backend/internal/user"
)

type GitHubAuthHandler struct {
	ClientID       string
	ClientSecret   string
	RedirectURL    string
	UserRepository *user.Repository
	AuthService    *auth.Service
	AuthRepository *auth.Repository
}

func NewGitHubAuthHandler(clientID, clientSecret, redirectURL string, userRepository *user.Repository, authService *auth.Service, authRepository *auth.Repository) *GitHubAuthHandler {
	return &GitHubAuthHandler{
		ClientID:       clientID,
		ClientSecret:   clientSecret,
		RedirectURL:    redirectURL,
		UserRepository: userRepository,
		AuthService:    authService,
		AuthRepository: authRepository,
	}
}

type GitHubTokenResponse struct {
	AccessToken string `json:"access_token"`
	TokenType   string `json:"token_type"`
	Scope       string `json:"scope"`
	Error       string `json:"error"`
	Description string `json:"error_description"`
}

type GitHubUserResponse struct {
	ID        int64  `json:"id"`
	Login     string `json:"login"`
	Name      string `json:"name"`
	AvatarURL string `json:"avatar_url"`
	Email     string `json:"email"`
}

type AppSession struct {
	AccessToken  string `json:"accessToken"`
	RefreshToken string `json:"refreshToken"`
}

func generateOAuthState() (string, error) {
	bytes := make([]byte, 32)

	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}

	return base64.URLEncoding.EncodeToString(bytes), nil
}

func (h *GitHubAuthHandler) Login(w http.ResponseWriter, r *http.Request) {
	state, err := generateOAuthState()
	if err != nil {
		http.Error(w, "failed to generate oauth state", http.StatusInternalServerError)
		return
	}

	http.SetCookie(w, &http.Cookie{
		Name:     "github_oauth_state",
		Value:    state,
		Path:     "/",
		HttpOnly: true,
		SameSite: http.SameSiteLaxMode,
		MaxAge:   10 * 60,
	})

	params := url.Values{}
	params.Add("client_id", h.ClientID)
	params.Add("redirect_uri", h.RedirectURL)
	params.Add("scope", "repo read:user user:email")
	params.Add("state", state)

	authURL := "https://github.com/login/oauth/authorize?" + params.Encode()

	http.Redirect(w, r, authURL, http.StatusTemporaryRedirect)
}

func (h *GitHubAuthHandler) Callback(w http.ResponseWriter, r *http.Request) {
	code := r.URL.Query().Get("code")
	state := r.URL.Query().Get("state")

	if code == "" {
		http.Error(w, "missing code", http.StatusBadRequest)
		return
	}

	if state == "" {
		http.Error(w, "missing state", http.StatusBadRequest)
		return
	}

	stateCookie, err := r.Cookie("github_oauth_state")
	if err != nil {
		http.Error(w, "missing oauth state cookie", http.StatusBadRequest)
		return
	}

	if stateCookie.Value != state {
		http.Error(w, "invalid oauth state", http.StatusBadRequest)
		return
	}

	http.SetCookie(w, &http.Cookie{
		Name:     "github_oauth_state",
		Value:    "",
		Path:     "/",
		HttpOnly: true,
		SameSite: http.SameSiteLaxMode,
		MaxAge:   -1,
	})

	appUser, err := h.authenticateWithGitHub(code)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	session, err := h.createAppSession(appUser.ID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	h.writeSessionResponse(w, r, session)
}

func (h *GitHubAuthHandler) authenticateWithGitHub(code string) (user.User, error) {
	tokenResponse, err := h.exchangeCodeForToken(code)
	if err != nil {
		return user.User{}, err
	}

	githubUser, err := h.fetchGitHubUser(tokenResponse.AccessToken)
	if err != nil {
		return user.User{}, err
	}

	return h.UserRepository.FindOrCreateUserByProviderAccount(
		"github",
		strconv.FormatInt(githubUser.ID, 10),
		githubUser.Login,
		githubUser.AvatarURL,
		tokenResponse.AccessToken,
	)
}

func (h *GitHubAuthHandler) createAppSession(userID int64) (AppSession, error) {
	accessToken, err := h.AuthService.GenerateAccessToken(userID)
	if err != nil {
		return AppSession{}, err
	}

	refreshToken, err := h.AuthService.GenerateRefreshToken()
	if err != nil {
		return AppSession{}, err
	}

	refreshTokenHash := h.AuthService.HashRefreshToken(refreshToken)

	err = h.AuthRepository.CreateRefreshToken(
		userID,
		refreshTokenHash,
		h.AuthService.RefreshTokenExpiresAt(),
	)
	if err != nil {
		return AppSession{}, err
	}

	return AppSession{
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
	}, nil
}

func (h *GitHubAuthHandler) writeSessionResponse(w http.ResponseWriter, r *http.Request, session AppSession) {
	redirectURL := "deployflow://auth/success?" + url.Values{
		"accessToken":  {session.AccessToken},
		"refreshToken": {session.RefreshToken},
	}.Encode()

	http.Redirect(w, r, redirectURL, http.StatusTemporaryRedirect)
}

func (h *GitHubAuthHandler) exchangeCodeForToken(code string) (GitHubTokenResponse, error) {
	form := url.Values{}
	form.Set("client_id", h.ClientID)
	form.Set("client_secret", h.ClientSecret)
	form.Set("code", code)
	form.Set("redirect_uri", h.RedirectURL)

	req, err := http.NewRequest(
		http.MethodPost,
		"https://github.com/login/oauth/access_token",
		strings.NewReader(form.Encode()),
	)
	if err != nil {
		return GitHubTokenResponse{}, err
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return GitHubTokenResponse{}, err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return GitHubTokenResponse{}, err
	}

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return GitHubTokenResponse{}, fmt.Errorf(
			"github token exchange failed: %s",
			string(body),
		)
	}

	var tokenResponse GitHubTokenResponse
	if err := json.Unmarshal(body, &tokenResponse); err != nil {
		return GitHubTokenResponse{}, err
	}

	if tokenResponse.Error != "" {
		return GitHubTokenResponse{}, errors.New(tokenResponse.Description)
	}

	if tokenResponse.AccessToken == "" {
		return GitHubTokenResponse{}, errors.New("github returned empty access token")
	}

	return tokenResponse, nil
}

func (h *GitHubAuthHandler) fetchGitHubUser(accessToken string) (GitHubUserResponse, error) {
	req, err := http.NewRequest(
		http.MethodGet,
		"https://api.github.com/user",
		nil,
	)
	if err != nil {
		return GitHubUserResponse{}, err
	}

	req.Header.Set("Authorization", "Bearer "+accessToken)
	req.Header.Set("Accept", "application/vnd.github+json")

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return GitHubUserResponse{}, err
	}
	defer resp.Body.Close()

	var githubUser GitHubUserResponse
	if err := json.NewDecoder(resp.Body).Decode(&githubUser); err != nil {
		return GitHubUserResponse{}, err
	}

	if githubUser.ID == 0 {
		return GitHubUserResponse{}, errors.New("github returned invalid user")
	}

	return githubUser, nil
}
