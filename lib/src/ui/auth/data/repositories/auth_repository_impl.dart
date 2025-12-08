

import '../../domain/entities/auth_credentials.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/role_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/firebase_realtime_auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;
  final FirebaseRealtimeAuthDataSource _firebaseDataSource;

  AuthRepositoryImpl(this._localDataSource, this._firebaseDataSource);

  @override
  Future<AuthResult> login(AuthCredentials credentials) async {
    try {
      final result = await _firebaseDataSource.login(credentials);

      if (result.isSuccess && result.user != null && result.token != null) {
        // Save to local storage
        await _localDataSource.saveToken(result.token!);
        await _localDataSource.saveUser(UserModel.fromEntity(result.user!).toJson());
      }

      return result;
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  @override
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final result = await _firebaseDataSource.register(
        name: name,
        email: email,
        password: password,
      );

      if (result.isSuccess && result.user != null && result.token != null) {
        // Save to local storage
        await _localDataSource.saveToken(result.token!);
        await _localDataSource.saveUser(UserModel.fromEntity(result.user!).toJson());
      }

      return result;
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  @override
  Future<bool> forgotPassword(String email) async {
    try {
      return await _firebaseDataSource.forgotPassword(email);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseDataSource.logout();
    await _localDataSource.clearAuthData();
  }

  @override
  Future<bool> get isLoggedIn async {
    final localAuth = await _localDataSource.isAuthenticated;
    if (localAuth) {
      // Também verificar o estado do Firebase Auth
      return await _firebaseDataSource.isLoggedIn;
    }
    return false;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    // Primeiro tentar obter do Firebase
    final user = await _firebaseDataSource.getCurrentUser();
    if (user != null) {
      // Atualizar o armazenamento local com os dados mais recentes
      await _localDataSource.saveUser(UserModel.fromEntity(user).toJson());
      return user;
    }

    // Se não estiver disponível no Firebase, tentar do armazenamento local
    final userData = await _localDataSource.getUser();
    if (userData != null) {
      return UserEntity(
        id: userData['id'] ?? '',
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
        emailVerified: userData['emailVerified'] ?? false,
        avatar: userData['avatar'],
        role: const RoleEntity(
          type: RoleType.employee,
          permissions: ['read'],
          description: 'Usuário padrão',
        ),
      );
    }
    return null;
  }

  @override
  Future<String?> getAuthToken() async {
    // Primeiro tentar obter token do Firebase
    final token = await _firebaseDataSource.getAuthToken();
    if (token != null) {
      // Atualizar armazenamento local
      await _localDataSource.saveToken(token);
      return token;
    }

    // Se não estiver disponível no Firebase, tentar do armazenamento local
    return await _localDataSource.getToken();
  }
}