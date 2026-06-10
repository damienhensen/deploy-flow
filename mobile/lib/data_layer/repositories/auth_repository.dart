import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> updateAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }

  Future<void> updateRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }
}
