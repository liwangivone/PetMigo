class LoginState {
  final String email;
  final String password;
  final bool isValid;

  LoginState({
    this.email = '',
    this.password = '',
  }) : isValid = email.isNotEmpty && password.isNotEmpty;
}