import 'package:equatable/equatable.dart';
import '../../models/clinic_model.dart';

abstract class ClinicState extends Equatable {
  const ClinicState();
  @override List<Object?> get props => [];
}

class ClinicInitial  extends ClinicState {}
class ClinicLoading  extends ClinicState {}
class ClinicError    extends ClinicState {
  final String message;
  const ClinicError(this.message);
  @override List<Object?> get props => [message];
}

class ClinicListLoaded extends ClinicState {
  final List<ClinicModel> list;
  const ClinicListLoaded(this.list);
  @override List<Object?> get props => [list];
}

class ClinicLoaded extends ClinicState {
  final ClinicModel clinic;
  const ClinicLoaded(this.clinic);
  @override List<Object?> get props => [clinic];
}

class ClinicSuccess extends ClinicState {}   // sukses create/update/delete
