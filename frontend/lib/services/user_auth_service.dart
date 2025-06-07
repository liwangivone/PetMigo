import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class AuthServices {
  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/users/login'),
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
      Uri.parse('http://localhost:8080/api/users/register'),
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