import '../entities/auth_result.dart';
import '../entities/auth_credentials.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<AuthResult> execute(AuthCredentials credentials) async {
    return await _authRepository.login(credentials);
  }
}