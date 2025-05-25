// model_login.dart
class LoginState {
  final String email;
  final String password;
  final bool isValid;
  final String? errorMessage;
  final bool isLoading;

  LoginState({
    this.email = '',
    this.password = '',
    this.errorMessage,
    this.isLoading = false,
  }) : isValid = email.isNotEmpty && password.isNotEmpty;

  LoginState copyWith({
    String? email,
    String? password,
    String? errorMessage,
    bool? isLoading,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}