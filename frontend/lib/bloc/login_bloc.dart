import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/model_login.dart';

abstract class LoginEvent {}

class PhoneChanged extends LoginEvent {
  final String phone;
  PhoneChanged(this.phone);
}

class PasswordChanged extends LoginEvent {
  final String password;
  PasswordChanged(this.password);
}

class LoginSubmitted extends LoginEvent {}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<PhoneChanged>((event, emit) {
      emit(LoginState(phone: event.phone, password: state.password));
    });

    on<PasswordChanged>((event, emit) {
      emit(LoginState(phone: state.phone, password: event.password));
    });

    on<LoginSubmitted>((event, emit) {
      // Simulasikan login logic
      print('Login dengan: ${state.phone}, ${state.password}');
    });
  }
}
