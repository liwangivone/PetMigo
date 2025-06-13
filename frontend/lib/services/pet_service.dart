import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/pet_model.dart';

class PetService {
  static const String baseUrl = 'http://localhost:8080/api/pet';

  // Ambil 1 pet
  Future<Map<String, dynamic>> getPetById(String petId) async {
    final response = await http.get(Uri.parse('$baseUrl/$petId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat data pet');
    }
  }

  // Ambil semua pet milik user
  Future<List<dynamic>> getPetsByUserId(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat daftar pet');
    }
  }

  // Daftarkan pet baru (POST dengan userId di query)
  Future<Map<String, dynamic>> createPet(String userId, Pet pet) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register?userId=$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pet.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal mendaftarkan pet');
    }
  }

  // Update pet
  Future<Map<String, dynamic>> updatePet(String petId, Pet pet) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$petId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pet.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memperbarui data pet');
    }
  }

  // Hapus pet
  Future<void> deletePet(String petId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$petId'));

    if (response.statusCode != 204) {
      throw Exception('Gagal menghapus pet');
    }
  }
}
