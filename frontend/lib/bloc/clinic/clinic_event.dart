import 'package:equatable/equatable.dart';
import '../../models/clinic_model.dart';

abstract class ClinicEvent extends Equatable {
  const ClinicEvent();
  @override List<Object?> get props => [];
}

class FetchAllClinics extends ClinicEvent {}

class FetchClinicById extends ClinicEvent {
  final String id;
  const FetchClinicById(this.id);
  @override List<Object?> get props => [id];
}

class CreateClinic extends ClinicEvent {
  final ClinicModel data;
  const CreateClinic(this.data);
  @override List<Object?> get props => [data];
}

class UpdateClinic extends ClinicEvent {
  final String id;
  final ClinicModel data;
  const UpdateClinic(this.id, this.data);
  @override List<Object?> get props => [id, data];
}

class DeleteClinic extends ClinicEvent {
  final String id;
  final String? vetId;
  const DeleteClinic(this.id, {this.vetId});
  @override List<Object?> get props => [id, vetId];
}
