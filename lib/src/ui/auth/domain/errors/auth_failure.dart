abstract class AuthFailure {
  final String message;

  const AuthFailure(this.message);
}

class NetworkAuthFailure extends AuthFailure {
  const NetworkAuthFailure(String message) : super(message);
}

class ServerAuthFailure extends AuthFailure {
  const ServerAuthFailure(String message) : super(message);
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure() : super('Credenciais inválidas');
}

class EmailNotVerifiedFailure extends AuthFailure {
  const EmailNotVerifiedFailure() : super('Email não verificado');
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure() : super('Usuário não encontrado');
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure() : super('Senha fraca');
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure() : super('Email já está em uso');
}

class TooManyRequestsFailure extends AuthFailure {
  const TooManyRequestsFailure() : super('Muitas tentativas. Tente novamente mais tarde');
}

class InvalidTokenFailure extends AuthFailure {
  const InvalidTokenFailure() : super('Token inválido');
}

class ExpiredTokenFailure extends AuthFailure {
  const ExpiredTokenFailure() : super('Token expirado');
}