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
      emit(LoginState(email: event.email, password: state.password));
    });

    on<PasswordChanged>((event, emit) {
      emit(LoginState(email: state.email, password: event.password));
    });

    on<LoginSubmitted>((event, emit) async {
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
          // Tambahkan logic lanjut jika perlu
        } else {
          print('Login gagal: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Error saat koneksi ke server: $e');
      }
    });
  }
}
