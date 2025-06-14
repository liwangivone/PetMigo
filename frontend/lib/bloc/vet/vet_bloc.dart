import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/vet_service.dart';
import 'vet_event.dart';
import 'vet_state.dart';

class VetBloc extends Bloc<VetEvent, VetState> {
  final VetService vetService;

  VetBloc(this.vetService) : super(const VetInitial()) {
    // ─── LOGIN ────────────────────────────────────────────────
    on<VetLoginRequested>((event, emit) async {
      emit(const VetLoading());
      try {
        final vet = await vetService.login(event.email, event.password);
        emit(VetAuthSuccess(vet));
      } catch (e) {
        emit(VetError(e.toString()));
      }
    });

    // ─── REGISTER ────────────────────────────────────────────
    on<VetRegisterRequested>((event, emit) async {
      emit(const VetLoading());
      try {
        final vet = await vetService.register(
          name: event.name,
          email: event.email,
          password: event.password,
          specialization: event.specialization,
          experienceYears: event.experienceYears,
          overview: event.overview,
          schedule: event.schedule,
        );
        emit(VetAuthSuccess(vet));
      } catch (e) {
        emit(VetError(e.toString()));
      }
    });

    // ─── FETCH LIST ──────────────────────────────────────────
    on<FetchAllVets>((event, emit) async {
      emit(const VetLoading());
      try {
        final vets = await vetService.fetchAllVets(); // List<VetModel>
        emit(VetListLoaded(vets));
      } catch (e) {
        emit(VetError(e.toString()));
      }
    });
  }
}
