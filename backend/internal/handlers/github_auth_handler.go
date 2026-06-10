package handlers

import (
	"encoding/json"
	"errors"
	"net/http"
	"net/url"
	"strconv"
	"strings"

	"github.com/damienhensen/deploy-flow/backend/internal/user"
)

type GitHubAuthHandler struct {
	ClientID       string
	ClientSecret   string
	RedirectURL    string
	UserRepository *user.Repository
}

func NewGitHubAuthHandler(clientID, clientSecret, redirectURL string, userRepository *user.Repository) *GitHubAuthHandler {
	return &GitHubAuthHandler{
		ClientID:       clientID,
		ClientSecret:   clientSecret,
		RedirectURL:    redirectURL,
		UserRepository: userRepository,
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

func (h *GitHubAuthHandler) Login(w http.ResponseWriter, r *http.Request) {
	params := url.Values{}
	params.Add("client_id", h.ClientID)
	params.Add("redirect_uri", h.RedirectURL)
	params.Add("scope", "repo read:user user:email")
	params.Add("state", "temporary-dev-state")

	authURL := "https://github.com/login/oauth/authorize?" + params.Encode()

	http.Redirect(w, r, authURL, http.StatusTemporaryRedirect)
}

func (h *GitHubAuthHandler) Callback(w http.ResponseWriter, r *http.Request) {
	code := r.URL.Query().Get("code")
	if code == "" {
		http.Error(w, "missing code", http.StatusBadRequest)
		return
	}

	tokenResponse, err := h.exchangeCodeForToken(code)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	githubUser, err := h.fetchGitHubUser(tokenResponse.AccessToken)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	appUser, err := h.UserRepository.FindOrCreateUserByProviderAccount(
		"github",
		strconv.FormatInt(githubUser.ID, 10),
		githubUser.Login,
		githubUser.AvatarURL,
		tokenResponse.AccessToken,
	)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	_, _ = w.Write([]byte("Logged in as user ID: " + strconv.FormatInt(appUser.ID, 10)))
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

	var tokenResponse GitHubTokenResponse
	if err := json.NewDecoder(resp.Body).Decode(&tokenResponse); err != nil {
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
