import '../../models/pet_model.dart';

abstract class PetState {
  const PetState();
}

class PetInitial extends PetState {}

class PetLoading extends PetState {}

class PetCreating extends PetState {}

class PetCreated extends PetState {
  final Pet pet;
  const PetCreated(this.pet);
}

class PetSuccess extends PetState {
  final String message;
  const PetSuccess(this.message);
}

class PetError extends PetState {
  final String message;
  const PetError(this.message);
}

class PetLoaded extends PetState {
  final List<Pet> pets;
  const PetLoaded(this.pets);
}
