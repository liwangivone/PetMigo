import 'dart:convert';
import 'package:frontend/services/url.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/petschedules_model.dart';

class PetScheduleService {
  static const String baseUrl = kPetScheduleAPI; // ← ganti saja

  /* ────── CRUD ────── */

  // POST /pet/{petId}
  Future<Map<String, dynamic>> createSchedule(String petId, PetSchedule sched) async {
    final res = await http.post(
      Uri.parse('$baseUrl/pet/$petId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(sched.toJson()),
    );
    if (res.statusCode == 200) return json.decode(res.body);
    throw Exception('Gagal membuat jadwal pet');
  }

  // PUT /schedules/{scheduleId}
  Future<Map<String, dynamic>> updateSchedule(String id, PetSchedule sched) async {
    final res = await http.put(
      Uri.parse('$baseUrl/schedules/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(sched.toJson()),
    );
    if (res.statusCode == 200) return json.decode(res.body);
    throw Exception('Gagal memperbarui jadwal pet');
  }

  // DELETE /{scheduleId}
  Future<void> deleteSchedule(String id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode != 204) throw Exception('Gagal menghapus jadwal pet');
  }

  // GET /user/{userId}
  Future<Map<String, dynamic>> getSchedulesByUserId(String userId) async {
    final res = await http.get(Uri.parse('$baseUrl/user/$userId'));
    if (res.statusCode == 200) return json.decode(res.body);
    throw Exception('Gagal mengambil jadwal berdasarkan user');
  }

    // GET /pet/{petId}
  Future<List<dynamic>> getSchedulesByPetId(String petId) async {
    final res = await http.get(Uri.parse('$baseUrl/pet/$petId'));
    if (res.statusCode == 200) return json.decode(res.body);
    throw Exception('Gagal mengambil jadwal pet');
  }
}
