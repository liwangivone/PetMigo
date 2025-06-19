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
    on<UpdatePet>(_onUpdatePet);
    on<DeletePet>(_onDeletePet);
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
      if (event.userId.isEmpty) {
        emit(const PetError('User ID kosong'));
        return;
      }

      final p = event.pet;

      if (p.name.trim().isEmpty || p.gender.trim().isEmpty) {
        emit(const PetError('Data pet belum lengkap'));
        return;
      }

      final upperGender = p.gender.toUpperCase();
      if (upperGender != 'MALE' && upperGender != 'FEMALE') {
        emit(const PetError('Gender harus MALE atau FEMALE'));
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final storedType = prefs.getString('pettype') ?? p.type;
      if (storedType.isEmpty) {
        emit(const PetError('Tipe pet tidak ditemukan'));
        return;
      }

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

      final jsonResp = await petService.createPet(event.userId.trim(), payload);
      final savedPet = Pet.fromJson(jsonResp);

      emit(PetCreated(savedPet));
      emit(const PetSuccess('Pet berhasil ditambahkan'));
      add(GetPetData());

    } catch (e) {
      final errorMessage = e.toString().contains('409')
          ? 'Nama pet sudah dipakai'
          : 'Gagal menambahkan pet';
      emit(PetError(errorMessage));
    }
  }

  Future<void> _onUpdatePet(UpdatePet event, Emitter<PetState> emit) async {
    emit(PetUpdating());
    try {
      final pet = event.pet;

      if (pet.name.trim().isEmpty || pet.gender.trim().isEmpty) {
        emit(const PetError('Data pet belum lengkap'));
        return;
      }

      final upperGender = pet.gender.toUpperCase();
      if (upperGender != 'MALE' && upperGender != 'FEMALE') {
        emit(const PetError('Gender harus MALE atau FEMALE'));
        return;
      }

      final updatedPet = Pet(
        id: pet.id,
        name: pet.name.trim(),
        gender: upperGender,
        type: pet.type,
        birthdate: pet.birthdate,
        breed: pet.breed?.trim(),
        weight: pet.weight,
        color: pet.color?.trim(),
        petSchedules: pet.petSchedules,
      );

      final response = await petService.updatePet(pet.id, updatedPet);

      emit(PetUpdated(Pet.fromJson(response)));
      emit(const PetSuccess('Pet berhasil diperbarui'));
      add(GetPetData());

    } catch (e) {
      emit(PetError('Gagal memperbarui data pet'));
    }
  }

  Future<void> _onDeletePet(DeletePet event, Emitter<PetState> emit) async {
    emit(PetDeleting());
    try {
      await petService.deletePet(event.petId);
      emit(PetDeleted());
      emit(const PetSuccess('Pet berhasil dihapus'));
      add(GetPetData());
    } catch (e) {
      emit(PetError('Gagal menghapus pet'));
    }
  }
}
