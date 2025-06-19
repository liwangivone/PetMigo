import 'package:equatable/equatable.dart';
import 'package:frontend/models/petschedules_model.dart';

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

// Add this to your existing PetScheduleEvent classes
class CreatePetSchedule extends PetScheduleEvent {
  final String petId;
  final PetSchedule schedule;

  const CreatePetSchedule(this.petId, this.schedule);

  @override
  List<Object> get props => [petId, schedule];
}