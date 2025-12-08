import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_credentials.dart';
import '../../domain/entities/auth_result.dart';
import 'auth_providers.dart';
import 'login_error_provider.dart';
import '../providers/role_provider.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, loading }

final authVmProvider = StateNotifierProvider<AuthVm, AuthStatus>((ref) {
  return AuthVm(AuthStatus.uninitialized, ref);
});

class AuthVm extends StateNotifier<AuthStatus> {
  final Ref _ref;

  AuthVm(super.state, this._ref) {
    // Initialize auth status after construction
    _initializeAuthStatus();
  }

  Future<void> _initializeAuthStatus() async {
    final repository = _ref.read(authRepositoryProvider);
    final isLoggedIn = await repository.isLoggedIn;
    if (isLoggedIn) {
      state = AuthStatus.authenticated;
    } else {
      state = AuthStatus.unauthenticated;
    }
  }

  Future<AuthResult> login(String email, String password) async {
    state = AuthStatus.loading;
    // Limpar mensagem de erro anterior
    _ref.read(loginErrorProvider.notifier).state = null;

    final useCase = _ref.read(loginUseCaseProvider);

    try {
      final credentials = AuthCredentials(
        email: email.trim(),
        password: password,
      );
      final result = await useCase.execute(credentials);

      if (result.isSuccess) {
        state = AuthStatus.authenticated;
        // Atualizar role do usuário atual
        if (result.user != null) {
          _ref.read(currentUserRoleProvider.notifier).state = result.user!.role;
        }
        // Limpar mensagem de erro após login bem-sucedido
        _ref.read(loginErrorProvider.notifier).state = null;
      } else {
        // Somente alterar o estado se estivermos em loading (ou seja, após tentativa de login)
        if (state == AuthStatus.loading) {
          state = AuthStatus.unauthenticated;
        }
        // Definir mensagem de erro
        _ref.read(loginErrorProvider.notifier).state = result.error ?? "Credenciais inválidas.";
      }

      return result;
    } catch (e) {
      // Somente alterar o estado se estivermos em loading (ou seja, após tentativa de login)
      if (state == AuthStatus.loading) {
        state = AuthStatus.unauthenticated;
      }
      // Definir mensagem de erro genérica em caso de exceção
      _ref.read(loginErrorProvider.notifier).state = "Erro ao fazer login. Tente novamente.";
      return AuthResult.failure(e.toString());
    }
  }

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AuthStatus.loading;
    final useCase = _ref.read(registerUseCaseProvider);

    try {
      final result = await useCase.execute(
        name: name.trim(),
        email: email.trim(),
        password: password,
      );

      if (result.isSuccess) {
        state = AuthStatus.authenticated;
      } else {
        state = AuthStatus.unauthenticated; // Keep unauthenticated on register failure
      }

      return result;
    } catch (e) {
      state = AuthStatus.unauthenticated;
      return AuthResult.failure(e.toString());
    }
  }

  Future<bool> forgotPassword(String email) async {
    state = AuthStatus.loading;
    final useCase = _ref.read(forgotPasswordUseCaseProvider);

    try {
      final success = await useCase.execute(email.trim());
      // Stay in unauthenticated after sending reset email
      state = AuthStatus.unauthenticated;
      return success;
    } catch (e) {
      state = AuthStatus.unauthenticated;
      return false;
    }
  }

  Future<void> logout() async {
    state = AuthStatus.loading;
    final useCase = _ref.read(logoutUseCaseProvider);

    try {
      await useCase.execute();
      state = AuthStatus.unauthenticated;
      // Limpar mensagem de erro após logout
      _ref.read(loginErrorProvider.notifier).state = null;
      // Limpar role do usuário após logout
      _ref.read(currentUserRoleProvider.notifier).state = null;
    } catch (e) {
      state = AuthStatus.unauthenticated;
    }
  }
}