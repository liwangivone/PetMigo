import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';

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

enum RegisterStatus { initial, loading, success, failure }

class RegisterState {
  final String email, name, password;
  final bool agreed;
  final RegisterStatus status;
  final String? errorMessage;
  final User? user;
  final bool submitted;
  final bool isLoading;
  
  // Validation getters
  bool get isValidEmail => email.isNotEmpty && email.contains('@') && email.contains('.');
  bool get isValidName => name.isNotEmpty && name.trim().length >= 2;
  bool get isValidPassword => password.isNotEmpty && password.length >= 6;
  bool get isValid => isValidEmail && isValidName && isValidPassword && agreed;
  
  // Individual field error getters for UI
  String? get nameError {
    if (!submitted || name.isEmpty) return null;
    if (name.trim().length < 2) return 'Nama minimal 2 karakter';
    return null;
  }
  
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
  
  const RegisterState({
    this.email = '',
    this.name = '',
    this.password = '',
    this.agreed = false,
    this.status = RegisterStatus.initial,
    this.errorMessage,
    this.user,
    this.submitted = false,
    this.isLoading = false,
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
    bool? isLoading,
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
    on<RegisterEmailChanged>((event, emit) => 
      emit(state.copyWith(
        email: event.email.trim(), 
        errorMessage: null, 
        status: RegisterStatus.initial
      ))
    );
    
    on<RegisterNameChanged>((event, emit) => 
      emit(state.copyWith(
        name: event.name.trim(), 
        errorMessage: null, 
        status: RegisterStatus.initial
      ))
    );
    
    on<RegisterPasswordChanged>((event, emit) => 
      emit(state.copyWith(
        password: event.password, 
        errorMessage: null, 
        status: RegisterStatus.initial
      ))
    );
    
    on<RegisterTermsToggled>((event, emit) => 
      emit(state.copyWith(
        agreed: !state.agreed, 
        errorMessage: null, 
        status: RegisterStatus.initial
      ))
    );
    
    on<RegisterSubmitted>((event, emit) async {
      emit(state.copyWith(submitted: true));
      
      // Validate all fields step by step
      if (state.name.isEmpty) {
        emit(state.copyWith(
          status: RegisterStatus.failure, 
          errorMessage: "Nama tidak boleh kosong", 
          isLoading: false
        ));
        return;
      }
      
      if (state.name.trim().length < 2) {
        emit(state.copyWith(
          status: RegisterStatus.failure, 
          errorMessage: "Nama minimal 2 karakter", 
          isLoading: false
        ));
        return;
      }
      
      if (state.email.isEmpty) {
        emit(state.copyWith(
          status: RegisterStatus.failure, 
          errorMessage: "Email tidak boleh kosong", 
          isLoading: false
        ));
        return;
      }
      
      if (!state.isValidEmail) {
        emit(state.copyWith(
          status: RegisterStatus.failure, 
          errorMessage: "Format email tidak valid", 
          isLoading: false
        ));
        return;
      }
      
      if (state.password.isEmpty) {
        emit(state.copyWith(
          status: RegisterStatus.failure, 
          errorMessage: "Password tidak boleh kosong", 
          isLoading: false
        ));
        return;
      }
      
      if (state.password.length < 6) {
        emit(state.copyWith(
          status: RegisterStatus.failure, 
          errorMessage: "Password minimal 6 karakter", 
          isLoading: false
        ));
        return;
      }
      
      if (!state.agreed) {
        emit(state.copyWith(
          status: RegisterStatus.failure, 
          errorMessage: "Anda harus menyetujui syarat & ketentuan", 
          isLoading: false
        ));
        return;
      }
      
      emit(state.copyWith(
        status: RegisterStatus.loading, 
        errorMessage: null, 
        isLoading: true
      ));
      
      try {
        final user = await authRepository.register(state.name, state.email, state.password);
        emit(state.copyWith(
          status: RegisterStatus.success, 
          user: user, 
          errorMessage: null, 
          isLoading: false
        ));
      } catch (e) {
        String errorMessage = e.toString();
        
        // Clean up error message
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.replaceFirst('Exception: ', '');
        }
        
        // Handle specific error messages
        if (errorMessage.toLowerCase().contains('email sudah digunakan')) {
          errorMessage = "Email sudah digunakan. Silakan gunakan email lain.";
        } else if (errorMessage.toLowerCase().contains('username sudah digunakan')) {
          errorMessage = "Username sudah digunakan. Silakan gunakan nama lain.";
        } else if (errorMessage.toLowerCase().contains('tidak dapat terhubung')) {
          errorMessage = "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.";
        } else if (errorMessage.toLowerCase().contains('timeout')) {
          errorMessage = "Koneksi timeout. Silakan coba lagi.";
        } else if (errorMessage.toLowerCase().contains('server')) {
          errorMessage = "Terjadi kesalahan pada server. Silakan coba lagi.";
        }
        
        emit(state.copyWith(
          status: RegisterStatus.failure, 
          errorMessage: errorMessage, 
          isLoading: false
        ));
      }
    });
  }
}