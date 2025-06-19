import 'package:frontend/models/petschedules_model.dart';
import 'package:equatable/equatable.dart';

abstract class PetScheduleState extends Equatable {
  const PetScheduleState();

  @override
  List<Object> get props => [];
}

class PetScheduleInitial extends PetScheduleState {}

class PetScheduleLoading extends PetScheduleState {}

class PetScheduleLoaded extends PetScheduleState {
  final List<PetSchedule> schedules;

  const PetScheduleLoaded(this.schedules);

  @override
  List<Object> get props => [schedules];
}

class PetScheduleError extends PetScheduleState {
  final String message;

  const PetScheduleError(this.message);

  @override
  List<Object> get props => [message];
}

class PetScheduleCreated extends PetScheduleState {
  final PetSchedule schedule;

  const PetScheduleCreated(this.schedule);

  @override
  List<Object> get props => [schedule];
}