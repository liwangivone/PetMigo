import 'package:equatable/equatable.dart';

abstract class PetScheduleEvent extends Equatable {
  const PetScheduleEvent();
  @override
  List<Object> get props => [];
}

class LoadPetSchedules extends PetScheduleEvent {}

/// 🆕 class event baru
class LoadPetSchedulesByPetId extends PetScheduleEvent {
  final String petId;
  const LoadPetSchedulesByPetId(this.petId);

  @override
  List<Object> get props => [petId];
}
