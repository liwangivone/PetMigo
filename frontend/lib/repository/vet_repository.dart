import 'package:frontend/models/vet_model.dart';
import 'package:frontend/services/vet_service.dart';

class VetRepository {
  final VetService vetService;

  const VetRepository({required this.vetService});

  /// ─── LOGIN ─────────────────────────────────────────────────────────────
  Future<VetModel> login(String email, String password) {
    return vetService.login(email, password);
  }

  /// ─── REGISTER ──────────────────────────────────────────────────────────
  Future<VetModel> register({
    required String name,
    required String email,
    required String password,
    required String specialization,
    required int experienceYears,
    required String overview,
    required String schedule,
  }) {
    return vetService.register(
      name: name,
      email: email,
      password: password,
      specialization: specialization,
      experienceYears: experienceYears,
      overview: overview,
      schedule: schedule,
    );
  }

  /// ─── FETCH ALL VETS ────────────────────────────────────────────────────
  Future<List<VetModel>> fetchAllVets() {
    return vetService.fetchAllVets();
  }
}
