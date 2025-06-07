import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthServices {
  static const String baseUrl = 'http://localhost:8080/api/users';

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception(_parseError(response));
    }
  }

  Future<User> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {'name': name, 'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception(_parseError(response));
    }
  }

  String _parseError(http.Response response) {
    try {
      final data = json.decode(response.body);
      if (data is Map && data['message'] != null) return data['message'];
      return response.body;
    } catch (_) {
      return response.body;
    }
  }
}
