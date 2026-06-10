package middelware

import (
	"context"
	"errors"
	"net/http"
	"strings"

	"github.com/damienhensen/deploy-flow/backend/internal/auth"
)

type contextKey string

const UserIDKey contextKey = "userID"

func RequireAuth(authService *auth.Service, next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		header := r.Header.Get("Authorization")

		if header == "" {
			http.Error(w, "missing authorization header", http.StatusUnauthorized)
			return
		}

		parts := strings.SplitN(header, " ", 2)
		if len(parts) != 2 || parts[0] != "Bearer" {
			http.Error(w, "invalid authorization header", http.StatusUnauthorized)
			return
		}

		claims, err := authService.ValidateAccessToken(parts[1])
		if err != nil {
			http.Error(w, "invalid access token", http.StatusUnauthorized)
			return
		}

		ctx := context.WithValue(r.Context(), UserIDKey, claims.UserID)

		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

func GetUserID(ctx context.Context) (int64, error) {
	userID, ok := ctx.Value(UserIDKey).(int64)
	if !ok {
		return 0, errors.New("user id missing from context")
	}

	return userID, nil
}
