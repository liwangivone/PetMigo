import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/petschedules_model.dart';
import 'package:frontend/services/petschedules_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pet_schedule_event.dart';
import 'pet_schedule_state.dart';

class PetScheduleBloc extends Bloc<PetScheduleEvent, PetScheduleState> {
  final PetScheduleService petScheduleService;

  PetScheduleBloc(this.petScheduleService) : super(PetScheduleInitial()) {
    on<LoadPetSchedules>(_onLoadPetSchedules);
    on<LoadPetSchedulesByPetId>(_onLoadPetSchedulesByPetId);
  }

  Future<void> _onLoadPetSchedules(
    LoadPetSchedules event,
    Emitter<PetScheduleState> emit,
  ) async {
    emit(PetScheduleLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userid') ?? '';

      if (userId.isEmpty) throw Exception('User ID not found');

      final rawData = await petScheduleService.getSchedulesByUserId(userId);
      final List<dynamic> pets = rawData['pets'] ?? [];

      final List<PetSchedule> allSchedules = [];

      for (var pet in pets) {
        final String petId = pet['petid'].toString();
        final String petName = pet['name'] ?? '';
        final String petType = pet['type'] ?? '';

        final List<dynamic> schedules = pet['petSchedule'] ?? [];

        for (var s in schedules) {
          final rawDate = s['date'];
          final DateTime parsedDate = rawDate is String
              ? DateTime.tryParse(rawDate) ?? DateTime.now()
              : DateTime.now();

          final int expense = (s['expense'] ?? 0) is int
              ? s['expense']
              : int.tryParse(s['expense'].toString()) ?? 0;

          final PetSchedule schedule = PetSchedule(
            id: s['schedule_id'].toString(),
            category: PetScheduleCategory.values.firstWhere(
              (e) => e.name.toLowerCase() ==
                  s['category'].toString().toLowerCase(),
              orElse: () => PetScheduleCategory.Others,
            ),
            expense: expense,
            description: s['description'] ?? '',
            date: parsedDate,
            petId: petId,
            petName: petName,
            petType: petType,
          );
          allSchedules.add(schedule);
        }
      }

      emit(PetScheduleLoaded(allSchedules));
    } catch (e, stackTrace) {
      print("Error in PetScheduleBloc: $e");
      print("Stack trace: $stackTrace");
      emit(PetScheduleError(e.toString()));
    }
  }

  Future<void> _onLoadPetSchedulesByPetId(
    LoadPetSchedulesByPetId event,
    Emitter<PetScheduleState> emit,
  ) async {
    emit(PetScheduleLoading());
    try {
      final rawList = await petScheduleService.getSchedulesByPetId(event.petId);

      final List<PetSchedule> parsed = rawList.map<PetSchedule>((s) {
        final rawDate = s['date'];
        final DateTime date = rawDate is String
            ? DateTime.tryParse(rawDate) ?? DateTime.now()
            : DateTime.now();

        final int expense = (s['expense'] ?? 0) is int
            ? s['expense']
            : int.tryParse(s['expense'].toString()) ?? 0;

        return PetSchedule(
          id: s['schedule_id'].toString(),
          category: PetScheduleCategory.values.firstWhere(
            (e) => e.name.toLowerCase() ==
                s['category'].toString().toLowerCase(),
            orElse: () => PetScheduleCategory.Others,
          ),
          expense: expense,
          description: s['description'] ?? '',
          date: date,
          petId: s['petid']?.toString() ?? event.petId,
          petName: s['petName'] ?? '',
          petType: s['petType'] ?? '',
        );
      }).toList();

      emit(PetScheduleLoaded(parsed));
    } catch (e, st) {
      print("Error in PetScheduleBloc (byPetId): $e\n$st");
      emit(PetScheduleError(e.toString()));
    }
  }
}
