import 'dart:convert';
import 'package:frontend/services/url.dart';
import 'package:http/http.dart' as http;
import '../models/clinic_model.dart';

class ClinicsService {
  final String baseUrl;
  const ClinicsService({this.baseUrl = kClinicAPI}); // ← ganti default

  /* ────── CRUD ────── */

  Future<ClinicModel> createClinic(ClinicModel d) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(d.toJson()),
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

  Future<ClinicModel> updateClinic(String id, ClinicModel d) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(d.toJson()),
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
