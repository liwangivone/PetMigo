import 'dart:convert';
import 'package:frontend/services/url.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/pet_model.dart';

class PetService {
  static const String baseUrl = kPetAPI;         // ← ganti

  // Ambil 1 pet
  Future<Map<String, dynamic>> getPetById(String id) async {
    final res = await http.get(Uri.parse('$baseUrl/$id'));
    if (res.statusCode == 200) return json.decode(res.body);
    throw Exception('Gagal memuat data pet');
  }

  // Ambil semua pet milik user
  Future<List<dynamic>> getPetsByUserId(String userId) async {
    final res = await http.get(Uri.parse('$baseUrl/user/$userId'));
    if (res.statusCode == 200) return json.decode(res.body);
    throw Exception('Gagal memuat daftar pet');
  }

  // Daftarkan pet baru
  Future<Map<String, dynamic>> createPet(String userId, Pet pet) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register?userId=$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pet.toJson()),
    );
    if (res.statusCode == 200) return json.decode(res.body);
    throw Exception('Gagal mendaftarkan pet');
  }

  // Update pet
  Future<Map<String, dynamic>> updatePet(String id, Pet pet) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pet.toJson()),
    );
    if (res.statusCode == 200) return json.decode(res.body);
    throw Exception('Gagal memperbarui data pet');
  }

  // Hapus pet
  Future<void> deletePet(String id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode != 204) throw Exception('Gagal menghapus pet');
  }
}
