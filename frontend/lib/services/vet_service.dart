import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vet_model.dart';
import 'package:frontend/services/url.dart';

class VetService {
  final String baseUrl;
  VetService({this.baseUrl = kVetAPI});

  // ========= AUTH =========
  Future<VetModel> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    if (res.statusCode == 200) {
      return VetModel.fromJson(json.decode(res.body));
    }
    throw Exception('Login gagal (${res.statusCode})');
  }

  Future<VetModel> register({
    required String name,
    required String email,
    required String password,
    required String specialization,
    required int experienceYears,
    required String overview,
    required String schedule,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'specialization': specialization,
        'experienceYears': experienceYears.toString(),
        'overview': overview,
        'schedule': schedule,
      },
    );

    if (res.statusCode == 200) {
      return VetModel.fromJson(json.decode(res.body));
    }
    throw Exception('Register gagal (${res.statusCode})');
  }

  // ========= FETCH =========
  Future<List<VetModel>> fetchAllVets() async {
    final res = await http.get(Uri.parse('$baseUrl/vet/list'));
    if (res.statusCode == 200) {
      final list = json.decode(res.body) as List;
      return list.map((e) => VetModel.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat daftar vet (${res.statusCode})');
  }
}
