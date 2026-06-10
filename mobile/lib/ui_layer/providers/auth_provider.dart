import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/data_layer/repositories/auth_repository.dart';
import 'package:mobile/data_layer/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final AuthService authService;

  AuthProvider({required this.authRepository, required this.authService}) {
    _listenForAuthRedirect();
  }

  bool isLoading = true;
  bool isAuthenticated = false;
  String? accessToken;

  StreamSubscription<Uri>? _authSubscription;

  void _listenForAuthRedirect() {
    _authSubscription = authService.authLinks.listen((uri) async {
      if (uri.scheme != 'deployflow') return;
      if (uri.host != 'auth') return;
      if (uri.path != '/success') return;

      final receivedAccessToken = uri.queryParameters['accessToken'];
      final receivedRefreshToken = uri.queryParameters['refreshToken'];

      if (receivedAccessToken == null || receivedRefreshToken == null) return;

      await authRepository.storeTokens(
        accessToken: receivedAccessToken,
        refreshToken: receivedRefreshToken,
      );

      accessToken = receivedAccessToken;
      isAuthenticated = true;
      isLoading = false;

      notifyListeners();
    });
  }

  Future<void> loginWithGitHub() async {
    await authService.loginWithGitHub();
  }

  Future<void> checkSession() async {
    isLoading = true;
    notifyListeners();

    final storedAccessToken = await authRepository.getAccessToken();
    final storedRefreshToken = await authRepository.getRefreshToken();

    if (storedAccessToken == null || storedRefreshToken == null) {
      isAuthenticated = false;
      isLoading = false;
      notifyListeners();
      return;
    }

    accessToken = storedAccessToken;
    isAuthenticated = true;

    await refreshSession();

    isLoading = false;
    notifyListeners();
  }

  Future<bool> refreshSession() async {
    final storedRefreshToken = await authRepository.getRefreshToken();

    if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
      await logout();
      return false;
    }

    try {
      final response = await authService.refresh(storedRefreshToken);

      final newAccessToken = response['accessToken'] as String?;
      final newRefreshToken = response['refreshToken'] as String?;

      if (newAccessToken == null || newRefreshToken == null) {
        await logout();
        return false;
      }

      await authRepository.storeTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      accessToken = newAccessToken;
      isAuthenticated = true;

      notifyListeners();

      return true;
    } catch (_) {
      await logout();
      return false;
    }
  }

  Future<void> logout() async {
    await authRepository.clearTokens();

    accessToken = null;
    isAuthenticated = false;

    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
