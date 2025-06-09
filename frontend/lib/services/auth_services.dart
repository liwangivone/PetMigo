import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthServices {
  static const String baseUrl = 'http://localhost:8080/api/users';
  static const Duration timeout = Duration(seconds: 10);

  Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {'email': email, 'password': password},
      ).timeout(timeout);

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          final user = User.fromJson(data);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userid', user.id);        // simpan id lokal di 'userid'
          await prefs.setString('uid', user.uid);           // simpan uid global di 'uid'
          await prefs.setString('name', user.name);
          await prefs.setString('email', user.email);
          await prefs.setString('phonenumber', user.phone);
          await prefs.setString('profileImageUrl', user.profileImageUrl ?? '');
          await prefs.setBool('isPremium', user.isPremium);

          return user;
        } catch (e) {
          throw Exception('Format respons tidak valid dari server');
        }
      } else {
        throw Exception(_parseError(response));
      }
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Koneksi timeout. Coba lagi.');
      }
      rethrow;
    }
  }

  Future<User> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        body: {'name': name, 'email': email, 'password': password},
      ).timeout(timeout);

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          return User.fromJson(data);
        } catch (e) {
          throw Exception('Format respons tidak valid dari server');
        }
      } else {
        throw Exception(_parseError(response));
      }
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Koneksi timeout. Coba lagi.');
      }
      rethrow;
    }
  }

  String _parseError(http.Response response) {
    try {
      final data = json.decode(response.body);
      if (data is Map && data['message'] != null) {
        return data['message'];
      }
      return response.body.isNotEmpty ? response.body : 'Terjadi kesalahan pada server';
    } catch (_) {
      if (response.body.isNotEmpty) {
        return response.body;
      }
      switch (response.statusCode) {
        case 400:
          return 'Data yang dikirim tidak valid';
        case 401:
          return 'Email atau password salah';
        case 409:
          return 'Email atau username sudah digunakan';
        case 500:
          return 'Terjadi kesalahan pada server';
        default:
          return 'Terjadi kesalahan tidak terduga (${response.statusCode})';
      }
    }
  }
}
