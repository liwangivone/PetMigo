// ================= pet_bloc.dart =================
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pet_event.dart';
import 'pet_state.dart';
import '../../models/pet_model.dart';
import '../../services/pet_service.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  final PetService petService;
  PetBloc(this.petService) : super(PetInitial()) {
    on<GetPetData>(_onGetPetData);
    on<CreatePet>(_onCreatePet);
  }

  Future<void> _onGetPetData(GetPetData event, Emitter<PetState> emit) async {
    emit(PetLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userid') ?? '';
      if (userId.isEmpty) throw Exception('User ID not found');

      final data = await petService.getPetsByUserId(userId);
      final pets = data.map<Pet>((e) => Pet.fromJson(e)).toList();
      emit(PetLoaded(pets));
    } catch (e) {
      emit(PetError('Failed to load pet data'));
    }
  }
  
  Future<void> _onCreatePet(CreatePet event, Emitter<PetState> emit) async {
    emit(PetCreating());

    try {
      // Validasi user ID
      if (event.userId.isEmpty) {
        emit(const PetError('User ID kosong'));
        return;
      }

      final p = event.pet;

      // Validasi field penting
      if (p.name.trim().isEmpty || p.gender.trim().isEmpty || p.birthdate == null) {
        emit(const PetError('Data pet belum lengkap'));
        return;
      }

      // Validasi gender
      final upperGender = p.gender.toUpperCase();
      if (upperGender != 'MALE' && upperGender != 'FEMALE') {
        emit(const PetError('Gender harus MALE atau FEMALE'));
        return;
      }

      // Ambil pet type
      final prefs = await SharedPreferences.getInstance();
      final storedType = prefs.getString('pettype') ?? p.type;
      if (storedType.isEmpty) {
        emit(const PetError('Tipe pet tidak ditemukan'));
        return;
      }

      // Build final payload
      final payload = Pet(
        id: p.id,
        name: p.name.trim(),
        gender: upperGender,
        type: storedType,
        birthdate: p.birthdate,
        breed: p.breed?.trim(),
        weight: p.weight,
        color: p.color?.trim(),
        petSchedules: p.petSchedules,
      );

      // Kirim ke service
      final jsonResp = await petService.createPet(event.userId.trim(), payload);
      final savedPet = Pet.fromJson(jsonResp);

      emit(PetCreated(savedPet));
      emit(const PetSuccess('Pet berhasil ditambahkan')); // ✅ pengumuman
      add(GetPetData());

    } catch (e) {
      final errorMessage = e.toString().contains('409')
          ? 'Nama pet sudah dipakai'
          : 'Gagal menambahkan pet';
      emit(PetError(errorMessage)); // ✅ pengumuman gagal
    }
  }
}