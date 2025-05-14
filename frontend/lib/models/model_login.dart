class LoginState {
  final String phone;
  final String password;
  final bool isValid;

  LoginState({
    this.phone = '',
    this.password = '',
  }) : isValid = phone.isNotEmpty && password.isNotEmpty;
}