import '../entities/auth_result.dart';
import '../entities/auth_credentials.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Login with email and password
  Future<AuthResult> login(AuthCredentials credentials);

  /// Register with email and password
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  });

  /// Send password reset email
  Future<bool> forgotPassword(String email);

  /// Logout the current user
  Future<void> logout();

  /// Check if user is currently logged in
  Future<bool> get isLoggedIn;

  /// Get current user
  Future<UserEntity?> getCurrentUser();

  /// Get current auth token
  Future<String?> getAuthToken();
}