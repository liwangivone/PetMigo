import 'package:frontend/models/pet_model.dart';
import 'package:frontend/services/pet_service.dart';

class PetRepository {
  final PetService petService;
  PetRepository({required this.petService});

  Future<Pet> getPetById(String petId) async {
    final json = await petService.getPetById(petId);
    return Pet.fromJson(json);
  }

  Future<List<Pet>> getPetsByUserId(String userId) async {
    final jsonList = await petService.getPetsByUserId(userId);
    return jsonList.map((json) => Pet.fromJson(json)).toList();
  }

  Future<Pet> createPet(String userId, Pet pet) async {
    final json = await petService.createPet(userId, pet);
    return Pet.fromJson(json);
  }

  Future<Pet> updatePet(String petId, Pet pet) async {
    final json = await petService.updatePet(petId, pet);
    return Pet.fromJson(json);
  }

  Future<void> deletePet(String petId) async {
    await petService.deletePet(petId);
  }
}
