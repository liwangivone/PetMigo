import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/services/clinic_service.dart';
import 'package:frontend/models/clinic_model.dart';
import 'clinic_event.dart';
import 'clinic_state.dart';

class ClinicBloc extends Bloc<ClinicEvent, ClinicState> {
  final ClinicsService service;
  ClinicBloc(this.service) : super(ClinicInitial()) {
    
    // READ ALL
    on<FetchAllClinics>((event, emit) async {
      emit(ClinicLoading());
      try {
        final clinics = await service.getAllClinics(); // langsung list<ClinicModel>
        emit(ClinicListLoaded(clinics));
      } catch (e) {
        emit(ClinicError(e.toString()));
      }
    });

    // READ ONE
    on<FetchClinicById>((event, emit) async {
      emit(ClinicLoading());
      try {
        final clinic = await service.getClinicById(event.id); // langsung ClinicModel
        emit(ClinicLoaded(clinic));
      } catch (e) {
        emit(ClinicError(e.toString()));
      }
    });

    // CREATE
    on<CreateClinic>((event, emit) async {
      emit(ClinicLoading());
      try {
        await service.createClinic(event.data); // langsung ClinicModel
        emit(ClinicSuccess());
      } catch (e) {
        emit(ClinicError(e.toString()));
      }
    });

    // UPDATE
    on<UpdateClinic>((event, emit) async {
      emit(ClinicLoading());
      try {
        await service.updateClinic(event.id, event.data); // ClinicModel
        emit(ClinicSuccess());
      } catch (e) {
        emit(ClinicError(e.toString()));
      }
    });

    // DELETE
    on<DeleteClinic>((event, emit) async {
      emit(ClinicLoading());
      try {
        await service.deleteClinic(event.id, vetId: event.vetId); // parameter vetId opsional
        emit(ClinicSuccess());
      } catch (e) {
        emit(ClinicError(e.toString()));
      }
    });
  }
}
