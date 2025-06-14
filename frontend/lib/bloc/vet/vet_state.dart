import 'package:equatable/equatable.dart';
import '../../models/vet_model.dart';

/// Status global BLoC.
abstract class VetState extends Equatable {
  const VetState();
  @override
  List<Object?> get props => [];
}

/// ⏳ Keadaan awal / idle.
class VetInitial extends VetState {
  const VetInitial();
}

/// 🔄 Sedang memproses permintaan (login, register, fetch).
class VetLoading extends VetState {
  const VetLoading();
}

/// ✅ Login / register sukses, menyimpan profil vet.
class VetAuthSuccess extends VetState {
  final VetModel vet;
  const VetAuthSuccess(this.vet);
  @override
  List<Object?> get props => [vet];
}

/// 📃 Berhasil memuat daftar vet.
class VetListLoaded extends VetState {
  final List<VetModel> vets;
  const VetListLoaded(this.vets);
  @override
  List<Object?> get props => [vets];
}

/// ❌ Terjadi kesalahan.
class VetError extends VetState {
  final String message;
  const VetError(this.message);
  @override
  List<Object?> get props => [message];
}
