import 'package:equatable/equatable.dart';

abstract class PetScheduleEvent extends Equatable {
  const PetScheduleEvent();

  @override
  List<Object> get props => [];
}

class LoadPetSchedules extends PetScheduleEvent {}
