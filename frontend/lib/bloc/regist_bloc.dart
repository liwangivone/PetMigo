import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// EVENTS
abstract class RegisterEvent {}

class RegisterEmailChanged extends RegisterEvent {
  final String email;
  RegisterEmailChanged(this.email);
}

class RegisterNameChanged extends RegisterEvent {
  final String name;
  RegisterNameChanged(this.name);
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;
  RegisterPasswordChanged(this.password);
}

class RegisterTermsToggled extends RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {}

// STATE
class RegisterState {
  final String email;
  final String name;
  final String password;
  final bool agreed;

  const RegisterState({
    this.email = '',
    this.name = '',
    this.password = '',
    this.agreed = false,
  });

  bool get isValid {
    return _isEmailValid(email) &&
        name.isNotEmpty &&
        password.length >= 6 &&
        agreed;
  }

  RegisterState copyWith({
    String? email,
    String? name,
    String? password,
    bool? agreed,
  }) {
    return RegisterState(
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      agreed: agreed ?? this.agreed,
    );
  }

  static bool _isEmailValid(String email) {
    return email.contains('@gmail.com') && email.contains('.');
  }
}

// BLOC
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(const RegisterState()) {
    on<RegisterEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<RegisterNameChanged>((event, emit) {
      emit(state.copyWith(name: event.name));
    });

    on<RegisterPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<RegisterTermsToggled>((event, emit) {
      emit(state.copyWith(agreed: !state.agreed));
    });

    on<RegisterSubmitted>((event, emit) async {
      if (!state.isValid) {
        print("Form tidak valid");
        return;
      }

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/users/register'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'email': state.email,
            'name': state.name,
            'password': state.password,
          },
        );

        if (response.statusCode == 200) {
          print('Registrasi berhasil');
          print('Response: ${response.body}');
        } else {
          print('Registrasi gagal: ${response.statusCode}');
          print('Response: ${response.body}');
        }
      } catch (e) {
        print('Error saat koneksi ke server: $e');
      }
    });
  }
}
