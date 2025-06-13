import 'package:frontend/models/petschedules_model.dart';

abstract class PetScheduleState {}

class PetScheduleInitial extends PetScheduleState {}

class PetScheduleLoading extends PetScheduleState {}

class PetScheduleLoaded extends PetScheduleState {
  final List<PetSchedule> schedules;

  PetScheduleLoaded(this.schedules);
}

class PetScheduleError extends PetScheduleState {
  final String message;

  PetScheduleError(this.message);
}
