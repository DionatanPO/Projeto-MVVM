class LoginResult {
  final String token;
  final String userName;
  final String? error;

  const LoginResult({
    required this.token,
    required this.userName,
    this.error,
  });

  bool get isSuccess => error == null && token.isNotEmpty;
}
