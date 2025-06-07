import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';

abstract class LoginEvent {}
class EmailChanged extends LoginEvent {
  final String email;
  EmailChanged(this.email);
}
class PasswordChanged extends LoginEvent {
  final String password;
  PasswordChanged(this.password);
}
class LoginSubmitted extends LoginEvent {}

class LoginState {
  final String email;
  final String password;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final User? user;
  final bool submitted;
  bool get isValid => email.isNotEmpty && password.isNotEmpty && email.contains('@');
  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.user,
    this.submitted = false,
  });
  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    User? user,
    bool? submitted,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      user: user ?? this.user,
      submitted: submitted ?? this.submitted,
    );
  }
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  LoginBloc({required this.authRepository}) : super(const LoginState()) {
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email, errorMessage: null, isSuccess: false));
    });
    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password, errorMessage: null, isSuccess: false));
    });
    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(submitted: true));
      if (state.email.isEmpty || state.password.isEmpty) {
        emit(state.copyWith(
          errorMessage: "Email dan password wajib diisi",
          isSuccess: false,
        ));
        return;
      }
      if (!state.email.contains('@')) {
        emit(state.copyWith(
          errorMessage: "Email tidak valid",
          isSuccess: false,
        ));
        return;
      }
      emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));
      try {
        final user = await authRepository.login(state.email, state.password);
        emit(state.copyWith(isLoading: false, isSuccess: true, user: user, errorMessage: null));
      } catch (e) {
        String msg = e.toString();
        if (msg.contains("email atau password salah")) {
          msg = "Email atau password salah";
        } else if (msg.contains("Exception:")) {
          msg = msg.replaceFirst("Exception:", "").trim();
        }
        emit(state.copyWith(isLoading: false, isSuccess: false, errorMessage: msg));
      }
    });
  }
}