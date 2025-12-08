import 'login_result.dart';

abstract class LoginRepository {
  Future<LoginResult> login({
    required String email,
    required String password,
  });
}
