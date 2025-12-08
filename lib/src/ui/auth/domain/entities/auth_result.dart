import '../entities/user_entity.dart';
import 'role_entity.dart';

class AuthResult {
  final bool success;
  final UserEntity? user;
  final String? token;
  final String? refreshToken;
  final String? error;

  const AuthResult({
    required this.success,
    this.user,
    this.token,
    this.refreshToken,
    this.error,
  });

  bool get isSuccess => success && error == null;

  bool get hasRole => user?.role.type != null;
  bool get hasRoleAdmin => user?.role.type == RoleType.admin;
  bool get hasRoleManager => user?.role.type == RoleType.manager;
  bool get hasRoleEmployee => user?.role.type == RoleType.employee;
  bool get hasRoleGuest => user?.role.type == RoleType.guest;

  bool hasPermission(String permission) => user?.role.hasPermission(permission) ?? false;

  factory AuthResult.success({
    required UserEntity user,
    required String token,
    String? refreshToken,
  }) {
    return AuthResult(
      success: true,
      user: user,
      token: token,
      refreshToken: refreshToken,
      error: null,
    );
  }

  factory AuthResult.failure(String error) {
    return AuthResult(
      success: false,
      user: null,
      token: null,
      refreshToken: null,
      error: error,
    );
  }
}