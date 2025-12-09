import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_credentials.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/role_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class DummyAuthRepository implements AuthRepository {
  final _dummyUser = const UserEntity(
    id: 'dummy_id',
    name: 'Dummy User',
    email: 'dummy@example.com',
    emailVerified: true,
    role: RoleEntity(type: RoleType.employee, permissions: [], description: 'Employee role'),
  );

  @override
  Future<AuthResult> login(AuthCredentials credentials) async {
    // Simulate a successful login
    return AuthResult.success(user: _dummyUser, token: 'dummy_token');
  }

  @override
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Simulate a successful registration
    return AuthResult.success(
        user: _dummyUser.copyWith(name: name, email: email),
        token: 'dummy_token');
  }

  @override
  Future<bool> forgotPassword(String email) async {
    // Simulate a successful forgot password request
    return true;
  }

  @override
  Future<void> logout() async {
    // Simulate a successful logout
    return;
  }

  @override
  Future<bool> get isLoggedIn async {
    // Always return false to make the login screen appear initially
    // The user can then "login" with dummy credentials.
    return false;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return _dummyUser;
  }

  @override
  Future<String?> getAuthToken() async {
    return 'dummy_token';
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return DummyAuthRepository();
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ForgotPasswordUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});