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
  
  // Validation getters
  bool get isValidEmail => email.isNotEmpty && email.contains('@') && email.contains('.');
  bool get isValidPassword => password.isNotEmpty && password.length >= 6;
  bool get isValid => isValidEmail && isValidPassword;
  
  // Individual field error getters
  String? get emailError {
    if (!submitted || email.isEmpty) return null;
    if (!email.contains('@')) return 'Format email tidak valid';
    if (!email.contains('.')) return 'Format email tidak valid';
    return null;
  }
  
  String? get passwordError {
    if (!submitted || password.isEmpty) return null;
    if (password.length < 6) return 'Password minimal 6 karakter';
    return null;
  }
  
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
      emit(state.copyWith(
        email: event.email.trim(), 
        errorMessage: null, 
        isSuccess: false
      ));
    });
    
    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(
        password: event.password, 
        errorMessage: null, 
        isSuccess: false
      ));
    });
    
    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(submitted: true));
      
      // Validate empty fields
      if (state.email.isEmpty) {
        emit(state.copyWith(
          errorMessage: "Email tidak boleh kosong",
          isSuccess: false,
        ));
        return;
      }
      
      if (state.password.isEmpty) {
        emit(state.copyWith(
          errorMessage: "Password tidak boleh kosong",
          isSuccess: false,
        ));
        return;
      }
      
      // Validate email format
      if (!state.isValidEmail) {
        emit(state.copyWith(
          errorMessage: "Format email tidak valid",
          isSuccess: false,
        ));
        return;
      }
      
      // Validate password length
      if (!state.isValidPassword) {
        emit(state.copyWith(
          errorMessage: "Password minimal 6 karakter",
          isSuccess: false,
        ));
        return;
      }
      
      emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));
      
      try {
        final user = await authRepository.login(state.email, state.password);
        emit(state.copyWith(
          isLoading: false, 
          isSuccess: true, 
          user: user, 
          errorMessage: null
        ));
      } catch (e) {
        String errorMessage = e.toString();
        
        // Clean up error message
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.replaceFirst('Exception: ', '');
        }
        
        // Handle specific error messages
        if (errorMessage.toLowerCase().contains('email atau password salah')) {
          errorMessage = "Email atau password salah";
        } else if (errorMessage.toLowerCase().contains('tidak dapat terhubung')) {
          errorMessage = "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.";
        } else if (errorMessage.toLowerCase().contains('timeout')) {
          errorMessage = "Koneksi timeout. Silakan coba lagi.";
        } else if (errorMessage.toLowerCase().contains('server')) {
          errorMessage = "Terjadi kesalahan pada server. Silakan coba lagi.";
        }
        
        emit(state.copyWith(
          isLoading: false, 
          isSuccess: false, 
          errorMessage: errorMessage
        ));
      }
    });
  }
}