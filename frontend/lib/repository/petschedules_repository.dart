import 'package:frontend/models/petschedules_model.dart';
import 'package:frontend/services/petschedules_service.dart';

class PetScheduleRepository {
  final PetScheduleService petScheduleService;

  PetScheduleRepository({required this.petScheduleService});

  Future<PetSchedule> createPetSchedule(String petId, PetSchedule schedule) async {
    final json = await petScheduleService.createSchedule(petId, schedule);
    return PetSchedule.fromJson(json);
  }

  Future<PetSchedule> updatePetSchedule(String scheduleId, PetSchedule schedule) async {
    final json = await petScheduleService.updateSchedule(scheduleId, schedule);
    return PetSchedule.fromJson(json);
  }

  Future<void> deletePetSchedule(String scheduleId) async {
    await petScheduleService.deleteSchedule(scheduleId);
  }

  Future<Map<String, dynamic>> getPetSchedulesByUserId(String userId) async {
    final json = await petScheduleService.getSchedulesByUserId(userId);
    return json;
  }
}
