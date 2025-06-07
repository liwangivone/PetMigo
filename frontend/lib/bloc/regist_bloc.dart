import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';

abstract class RegisterEvent {}
class RegisterEmailChanged extends RegisterEvent { final String email; RegisterEmailChanged(this.email);}
class RegisterNameChanged extends RegisterEvent { final String name; RegisterNameChanged(this.name);}
class RegisterPasswordChanged extends RegisterEvent { final String password; RegisterPasswordChanged(this.password);}
class RegisterTermsToggled extends RegisterEvent {}
class RegisterSubmitted extends RegisterEvent {}

enum RegisterStatus { initial, loading, success, failure }

class RegisterState {
  final String email, name, password;
  final bool agreed;
  final RegisterStatus status;
  final String? errorMessage;
  final User? user;
  final bool submitted;
  final bool isLoading; // Tambahkan properti ini
  bool get isValid =>
      email.isNotEmpty &&
      email.contains('@') &&
      name.isNotEmpty &&
      password.length >= 6 &&
      agreed;
  const RegisterState({
    this.email = '',
    this.name = '',
    this.password = '',
    this.agreed = false,
    this.status = RegisterStatus.initial,
    this.errorMessage,
    this.user,
    this.submitted = false,
    this.isLoading = false, // default false
  });
  RegisterState copyWith({
    String? email,
    String? name,
    String? password,
    bool? agreed,
    RegisterStatus? status,
    String? errorMessage,
    User? user,
    bool? submitted,
    bool? isLoading, // tambahkan
  }) {
    return RegisterState(
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      agreed: agreed ?? this.agreed,
      status: status ?? this.status,
      errorMessage: errorMessage,
      user: user ?? this.user,
      submitted: submitted ?? this.submitted,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;
  RegisterBloc({required this.authRepository}) : super(const RegisterState()) {
    on<RegisterEmailChanged>((event, emit) => emit(state.copyWith(email: event.email, errorMessage: null, status: RegisterStatus.initial)));
    on<RegisterNameChanged>((event, emit) => emit(state.copyWith(name: event.name, errorMessage: null, status: RegisterStatus.initial)));
    on<RegisterPasswordChanged>((event, emit) => emit(state.copyWith(password: event.password, errorMessage: null, status: RegisterStatus.initial)));
    on<RegisterTermsToggled>((event, emit) => emit(state.copyWith(agreed: !state.agreed, errorMessage: null, status: RegisterStatus.initial)));
    on<RegisterSubmitted>((event, emit) async {
      emit(state.copyWith(submitted: true));
      if (state.name.isEmpty) {
        emit(state.copyWith(status: RegisterStatus.failure, errorMessage: "Nama tidak boleh kosong", isLoading: false));
        return;
      }
      if (state.email.isEmpty) {
        emit(state.copyWith(status: RegisterStatus.failure, errorMessage: "Email tidak boleh kosong", isLoading: false));
        return;
      }
      if (!state.email.contains('@')) {
        emit(state.copyWith(status: RegisterStatus.failure, errorMessage: "Email tidak valid", isLoading: false));
        return;
      }
      if (state.password.isEmpty) {
        emit(state.copyWith(status: RegisterStatus.failure, errorMessage: "Password tidak boleh kosong", isLoading: false));
        return;
      }
      if (state.password.length < 6) {
        emit(state.copyWith(status: RegisterStatus.failure, errorMessage: "Password minimal 6 karakter", isLoading: false));
        return;
      }
      if (!state.agreed) {
        emit(state.copyWith(status: RegisterStatus.failure, errorMessage: "Anda harus menyetujui syarat & ketentuan", isLoading: false));
        return;
      }
      emit(state.copyWith(status: RegisterStatus.loading, errorMessage: null, isLoading: true));
      try {
        final user = await authRepository.register(state.name, state.email, state.password);
        emit(state.copyWith(status: RegisterStatus.success, user: user, errorMessage: null, isLoading: false));
      } catch (e) {
        String msg = e.toString();
        if (msg.contains("Email sudah digunakan")) {
          msg = "Email sudah digunakan";
        } else if (msg.contains("Username sudah digunakan")) {
          msg = "Username sudah digunakan";
        } else if (msg.contains("Exception:")) {
          msg = msg.replaceFirst("Exception:", "").trim();
        }
        emit(state.copyWith(status: RegisterStatus.failure, errorMessage: msg, isLoading: false));
      }
    });
  }
}