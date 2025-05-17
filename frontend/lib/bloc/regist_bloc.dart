import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState()) {
    on<RegisterNameChanged>((event, emit) => emit(state.copyWith(name: event.name)));
    on<RegisterPhoneChanged>((event, emit) => emit(state.copyWith(phone: event.phone)));
    on<RegisterPasswordChanged>((event, emit) => emit(state.copyWith(password: event.password)));
    on<RegisterTermsToggled>((event, emit) => emit(state.copyWith(agreed: !state.agreed)));
    on<RegisterSubmitted>((event, emit) {
      if (state.isValid) {
        // Di sini kamu bisa panggil service untuk registrasi
        print("Form Submitted: ${state.name}, ${state.phone}, ${state.password}");
      }
    });
  }
}

class RegisterState {
  final String name;
  final String phone;
  final String password;
  final bool agreed;
  final bool isValid;

  RegisterState({
    this.name = '',
    this.phone = '',
    this.password = '',
    this.agreed = false,
  }) : isValid = name.isNotEmpty && phone.isNotEmpty && password.isNotEmpty && agreed;

  RegisterState copyWith({
    String? name,
    String? phone,
    String? password,
    bool? agreed,
  }) {
    return RegisterState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      agreed: agreed ?? this.agreed,
    );
  }
}


abstract class RegisterEvent {}

class RegisterNameChanged extends RegisterEvent {
  final String name;
  RegisterNameChanged(this.name);
}

class RegisterPhoneChanged extends RegisterEvent {
  final String phone;
  RegisterPhoneChanged(this.phone);
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;
  RegisterPasswordChanged(this.password);
}

class RegisterTermsToggled extends RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {}