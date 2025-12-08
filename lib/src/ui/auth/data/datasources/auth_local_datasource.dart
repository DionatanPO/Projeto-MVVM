import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

class AuthLocalDataSource {
  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userKey = 'current_user';
  
  final FlutterSecureStorage _secureStorage;
  final GetStorage _storage;

  AuthLocalDataSource(this._secureStorage, this._storage);

  // Auth tokens
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  // User data
  Future<void> saveUser(Map<String, dynamic> userData) async {
    await _storage.write(_userKey, userData);
  }

  Future<Map<String, dynamic>?> getUser() async {
    return _storage.read(_userKey);
  }

  Future<void> clearUser() async {
    await _storage.remove(_userKey);
  }

  // Combined operations
  Future<void> clearAuthData() async {
    await clearTokens();
    await clearUser();
  }

  Future<bool> get isAuthenticated async {
    final token = await _secureStorage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }
}