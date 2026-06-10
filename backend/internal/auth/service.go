package auth

import (
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

type Service struct {
	JWTSecret string
}

func NewService(jwtSecret string) *Service {
	return &Service{
		JWTSecret: jwtSecret,
	}
}

type Claims struct {
	UserID int64 `json:"user_id"`
	jwt.RegisteredClaims
}

func (s *Service) GenerateAccessToken(userID int64) (string, error) {
	claims := Claims{
		UserID: userID,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(15 * time.Minute)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	return token.SignedString([]byte(s.JWTSecret))
}

func (s *Service) GenerateRefreshToken() (string, error) {
	bytes := make([]byte, 32)

	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}

	return base64.URLEncoding.EncodeToString(bytes), nil
}

func (s *Service) RefreshTokenExpiresAt() time.Time {
	return time.Now().Add(30 * 24 * time.Hour)
}

func (s *Service) HashRefreshToken(refreshToken string) string {
	hash := sha256.Sum256([]byte(refreshToken))
	return hex.EncodeToString(hash[:])
}
