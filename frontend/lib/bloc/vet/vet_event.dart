import 'package:equatable/equatable.dart';

/// Semua aksi terkait dokter hewan.
abstract class VetEvent extends Equatable {
  const VetEvent();
  @override
  List<Object?> get props => [];
}

/// 🔐 Login dengan email & password.
class VetLoginRequested extends VetEvent {
  final String email;
  final String password;

  // ✅ Named parameters for compatibility with UI
  const VetLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// 📝 Registrasi akun dokter hewan baru.
class VetRegisterRequested extends VetEvent {
  final String name;
  final String email;
  final String password;
  final String specialization;
  final int experienceYears;
  final String overview;
  final String schedule;

  const VetRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.specialization,
    required this.experienceYears,
    required this.overview,
    required this.schedule,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        specialization,
        experienceYears,
        overview,
        schedule,
      ];
}

/// 📥 Ambil seluruh daftar dokter hewan.
class FetchAllVets extends VetEvent {
  const FetchAllVets();
}
