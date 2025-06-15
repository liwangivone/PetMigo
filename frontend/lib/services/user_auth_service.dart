import 'package:frontend/services/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class AuthServices {
  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$kUserAPI/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Login gagal');
    }
  }

  Future<User> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$kUserAPI/register'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'name': name, 'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Registrasi gagal');
    }
  }
}
