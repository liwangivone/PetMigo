import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/petschedules_model.dart';

class PetScheduleService {
  static const String baseUrl = 'http://localhost:8080/api/petschedules';

  // POST /pet/{petId}
  Future<Map<String, dynamic>> createSchedule(String petId, PetSchedule schedule) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pet/$petId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(schedule.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal membuat jadwal pet');
    }
  }

  // PUT /schedules/{scheduleId}
  Future<Map<String, dynamic>> updateSchedule(String scheduleId, PetSchedule schedule) async {
    final response = await http.put(
      Uri.parse('$baseUrl/schedules/$scheduleId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(schedule.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memperbarui jadwal pet');
    }
  }

  // DELETE /{scheduleId}
  Future<void> deleteSchedule(String scheduleId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$scheduleId'));

    if (response.statusCode != 204) {
      throw Exception('Gagal menghapus jadwal pet');
    }
  }

  // GET /user/{userId}
  Future<Map<String, dynamic>> getSchedulesByUserId(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal mengambil jadwal berdasarkan user');
    }
  }
}
  