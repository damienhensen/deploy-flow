import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // final AuthRepository authRepository;

  AuthProvider(); // this.authRepository

  bool isLoading = true;
  bool isAuthenticated = false;
  String? token;

  Future<void> checkSession() async {
    isLoading = true;
    notifyListeners();

    // token = await authRepository.getStoredToken();
    isAuthenticated = false;

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    // await authRepository.logout();

    token = null;
    isAuthenticated = false;

    notifyListeners();
  }
}
