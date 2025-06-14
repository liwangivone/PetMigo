// pet_event.dart
import 'package:frontend/models/pet_model.dart';

abstract class PetEvent {}
class GetPetData extends PetEvent {}
class CreatePet extends PetEvent {
  final String userId;
  final Pet pet;

  CreatePet({required this.userId, required this.pet});
}
