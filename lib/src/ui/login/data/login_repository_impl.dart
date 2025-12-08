import '../domain/login_repository.dart';
import '../domain/login_result.dart';

class LoginRepositoryImpl implements LoginRepository {
  @override
  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    // Simulação de atraso de rede/API
    await Future.delayed(const Duration(milliseconds: 600));

    if (email == 'demo@email.com' && password == '123456') {
      return const LoginResult(
        token: 'fake-token',
        userName: 'Demo User',
      );
    }

    return const LoginResult(
      token: '',
      userName: '',
      error: 'Credenciais inválidas',
    );
  }
}
