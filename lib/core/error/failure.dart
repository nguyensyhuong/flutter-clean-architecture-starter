class AppFailure {
  const AppFailure(this.message);

  final String message;
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

class AuthenticationFailure extends AppFailure {
  const AuthenticationFailure(super.message);
}
