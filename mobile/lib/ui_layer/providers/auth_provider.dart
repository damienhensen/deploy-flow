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

    accessToken = await authRepository.getAccessToken();
    isAuthenticated = accessToken != null && accessToken!.isNotEmpty;

    isLoading = false;
    notifyListeners();
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
