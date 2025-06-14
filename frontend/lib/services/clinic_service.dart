import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/clinic_model.dart';

class ClinicsService {
  final String baseUrl;
  const ClinicsService({this.baseUrl = 'http://localhost:8080/api/clinics'});

  /* ────── CRUD ────── */

  Future<ClinicModel> createClinic(ClinicModel data) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );
    return ClinicModel.fromJson(jsonDecode(res.body));
  }

  Future<List<ClinicModel>> getAllClinics() async {
    final res  = await http.get(Uri.parse(baseUrl));
    final list = jsonDecode(res.body) as List;
    return list.map((e) => ClinicModel.fromJson(e)).toList();
  }

  Future<ClinicModel> getClinicById(String id) async {
    final res = await http.get(Uri.parse('$baseUrl/$id'));
    return ClinicModel.fromJson(jsonDecode(res.body));
  }

  Future<ClinicModel> updateClinic(String id, ClinicModel data) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );
    return ClinicModel.fromJson(jsonDecode(res.body));
  }

  Future<void> deleteClinic(String id, {String? vetId}) async {
    final uri = vetId == null
        ? Uri.parse('$baseUrl/$id')
        : Uri.parse('$baseUrl/$id?vetId=$vetId');
    await http.delete(uri);
  }
}
