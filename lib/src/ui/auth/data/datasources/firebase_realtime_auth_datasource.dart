import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/entities/auth_result.dart';
import '../../domain/entities/auth_credentials.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/role_entity.dart';
import '../models/user_model.dart';

class FirebaseRealtimeAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseDatabase _database;

  FirebaseRealtimeAuthDataSource(this._firebaseAuth, this._database);

  Future<AuthResult> login(AuthCredentials credentials) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: credentials.email,
        password: credentials.password,
      );

      final user = userCredential.user;
      if (user != null) {
        // Pegar dados adicionais do Realtime Database
        final userSnapshot = await _database.ref('users/${user.uid}').once();

        UserEntity userEntity;
        if (userSnapshot.snapshot.exists) {
          final userData = Map<String, dynamic>.from(userSnapshot.snapshot.value as Map);
          userEntity = UserModel.fromJson({
            'id': user.uid,
            'name': (userData['name'] as String?) ?? (user.displayName ?? ''),
            'email': user.email ?? credentials.email,
            'email_verified': user.emailVerified,
            'avatar': (userData['avatar'] as String?) ?? (user.photoURL ?? ''),
            'role': (userData['role'] as Map<String, dynamic>?) ?? {
              'type': 'employee',
              'permissions': ['read'],
              'description': 'Usuário padrão',
            },
          }).toEntity();
        } else {
          // Se o usuário não existir no Realtime DB, criar um usuário básico
          userEntity = UserEntity(
            id: user.uid,
            name: user.displayName ?? credentials.email.split('@')[0],
            email: user.email ?? credentials.email,
            emailVerified: user.emailVerified,
            avatar: user.photoURL ?? '',
            role: const RoleEntity(
              type: RoleType.employee,
              permissions: ['read'],
              description: 'Usuário padrão',
            ),
          );
        }

        final idToken = await user.getIdToken();
        if (idToken == null) {
          return AuthResult.failure('Falha ao obter token de autenticação');
        }

        return AuthResult.success(
          user: userEntity,
          token: idToken,
        );
      } else {
        return AuthResult.failure('Usuário não encontrado');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Erro desconhecido';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Nenhuma conta encontrada com este e-mail.';
          break;
        case 'wrong-password':
          errorMessage = 'Senha incorreta.';
          break;
        case 'user-disabled':
          errorMessage = 'Esta conta foi desativada.';
          break;
        case 'too-many-requests':
          errorMessage = 'Muitas tentativas de login. Tente novamente mais tarde.';
          break;
        default:
          errorMessage = e.message ?? 'Erro ao fazer login.';
      }
      return AuthResult.failure(errorMessage);
    } catch (e) {
      return AuthResult.failure('Erro de conexão: ${e.toString()}');
    }
  }

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // Salvar dados adicionais no Realtime Database
        await _database.ref('users/${user.uid}').set({
          'name': name,
          'email': email,
          'role': {
            'type': 'employee',
            'permissions': ['read', 'write'],
            'description': 'Usuário padrão',
          },
          'created_at': ServerValue.timestamp,
        });

        // Atualizar o nome do usuário no Firebase Auth
        await user.updateDisplayName(name);

        final idToken = await user.getIdToken();
        if (idToken == null) {
          return AuthResult.failure('Falha ao obter token de autenticação');
        }

        final userEntity = UserEntity(
          id: user.uid,
          name: name,
          email: user.email ?? email,
          emailVerified: user.emailVerified,
          avatar: user.photoURL ?? '',
          role: const RoleEntity(
            type: RoleType.employee,
            permissions: ['read', 'write'],
            description: 'Usuário padrão',
          ),
        );

        return AuthResult.success(
          user: userEntity,
          token: idToken,
        );
      } else {
        return AuthResult.failure('Erro ao criar usuário');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Erro desconhecido';
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Este e-mail já está em uso.';
          break;
        case 'weak-password':
          errorMessage = 'A senha é muito fraca.';
          break;
        case 'invalid-email':
          errorMessage = 'O e-mail fornecido é inválido.';
          break;
        default:
          errorMessage = e.message ?? 'Erro ao registrar usuário.';
      }
      return AuthResult.failure(errorMessage);
    } catch (e) {
      return AuthResult.failure('Erro de conexão: ${e.toString()}');
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> get isLoggedIn async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null && currentUser.emailVerified;
  }

  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        final userSnapshot = await _database.ref('users/${user.uid}').once();
        if (userSnapshot.snapshot.exists) {
          final userData = Map<String, dynamic>.from(userSnapshot.snapshot.value as Map);
          return UserModel.fromJson({
            'id': user.uid,
            'name': (userData['name'] as String?) ?? (user.displayName ?? ''),
            'email': user.email ?? '',
            'email_verified': user.emailVerified,
            'avatar': (userData['avatar'] as String?) ?? (user.photoURL ?? ''),
            'role': (userData['role'] as Map<String, dynamic>?) ?? {
              'type': 'employee',
              'permissions': ['read'],
              'description': 'Usuário padrão',
            },
          }).toEntity();
        } else {
          // Se o usuário não existir no Realtime DB, retornar informações básicas
          return UserEntity(
            id: user.uid,
            name: user.displayName ?? user.email?.split('@')[0] ?? 'Usuário',
            email: user.email ?? '',
            emailVerified: user.emailVerified,
            avatar: user.photoURL ?? '',
            role: const RoleEntity(
              type: RoleType.employee,
              permissions: ['read'],
              description: 'Usuário padrão',
            ),
          );
        }
      } catch (e) {
        // Em caso de erro ao buscar no Realtime DB, retornar informações básicas
        return UserEntity(
          id: user.uid,
          name: user.displayName ?? user.email?.split('@')[0] ?? 'Usuário',
          email: user.email ?? '',
          emailVerified: user.emailVerified,
          avatar: user.photoURL ?? '',
          role: const RoleEntity(
            type: RoleType.employee,
            permissions: ['read'],
            description: 'Usuário padrão',
          ),
        );
      }
    }
    return null;
  }

  Future<String?> getAuthToken() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  // Método para atualizar as informações do usuário no Realtime Database
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? avatar,
  }) async {
    if (name != null || avatar != null) {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (avatar != null) updates['avatar'] = avatar;
      updates['updated_at'] = ServerValue.timestamp;

      await _database.ref('users/$userId').update(updates);
    }
  }

  // Método para atualizar o papel (role) do usuário (para administração)
  Future<void> updateUserRole({
    required String userId,
    required String roleType,
    List<String> permissions = const [],
    String description = 'Usuário padrão',
  }) async {
    final updateData = {
      'role': {
        'type': roleType,
        'permissions': permissions,
        'description': description,
      },
      'updated_at': ServerValue.timestamp,
    };

    await _database.ref('users/$userId').update(updateData);
  }
}