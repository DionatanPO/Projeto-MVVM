import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _authRepository;

  ForgotPasswordUseCase(this._authRepository);

  Future<bool> execute(String email) async {
    return await _authRepository.forgotPassword(email);
  }
}