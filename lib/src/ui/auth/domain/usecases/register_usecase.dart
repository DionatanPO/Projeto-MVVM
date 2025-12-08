import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<AuthResult> execute({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _authRepository.register(
      name: name,
      email: email,
      password: password,
    );
  }
}