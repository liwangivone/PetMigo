// login_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/model_login.dart';
import 'package:http/http.dart' as http;

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

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(
        email: event.email,
        errorMessage: null,
      ));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(
        password: event.password,
        errorMessage: null,
      ));
    });

      on<LoginSubmitted>((event, emit) async {
        if (!state.isValid) return;

        emit(state.copyWith(isLoading: true, errorMessage: null));
        
        try {
          final response = await http.post(
            Uri.parse('http://localhost:8080/api/users/login'),
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: {
              'email': state.email,
              'password': state.password,
            },
          );

          if (response.statusCode == 200) {
            print('Login berhasil');
            print('Response body: ${response.body}');
            emit(state.copyWith(
              isLoading: false,
              isSuccess: true, // Set success ke true
            ));
          } else {
            emit(state.copyWith(
              isLoading: false,
              errorMessage: 'Email atau password salah',
            ));
          }
        } catch (e) {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: 'Terjadi kesalahan. Silakan coba lagi.',
          ));
        }
      });
  }
}