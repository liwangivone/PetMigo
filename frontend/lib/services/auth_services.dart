import 'dart:async';                                // ← untuk TimeoutException
import 'dart:convert';
import 'dart:io';
import 'package:frontend/services/url.dart';        // pastikan file url.dart ada di folder services
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthServices {
  static const Duration timeout = Duration(seconds: 10);

  /* ────── LOGIN ────── */
  Future<User> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$kUserAPI/login'),
            body: {'email': email, 'password': password},
          )
          .timeout(timeout);

      final data  = _validateResponse(response);
      final user  = User.fromJson(data);
      await _saveUserToPrefs(user);
      return user;
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on TimeoutException {
      throw Exception('Koneksi timeout. Coba lagi.');
    } catch (e) {
      rethrow; // kesalahan lain diteruskan
    }
  }

  /* ────── REGISTER ────── */
  Future<User> register(String name, String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$kUserAPI/register'),
            body: {'name': name, 'email': email, 'password': password},
          )
          .timeout(timeout);

      final data = _validateResponse(response);
      return User.fromJson(data);
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on TimeoutException {
      throw Exception('Koneksi timeout. Coba lagi.');
    } catch (e) {
      rethrow;
    }
  }

  /* ────── Helper: cache user ────── */
  Future<void> _saveUserToPrefs(User u) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('userid',          u.id);
    await p.setString('uid',             u.uid);
    await p.setString('name',            u.name);
    await p.setString('email',           u.email);
    await p.setString('phonenumber',     u.phone);
    await p.setString('profileImageUrl', u.profileImageUrl ?? '');
    await p.setBool  ('isPremium',       u.isPremium);
  }

  /* ────── Helper: validasi respons ────── */
  dynamic _validateResponse(http.Response res) {
    if (res.statusCode == 200) {
      try {
        return json.decode(res.body);
      } catch (_) {
        throw Exception('Format respons tidak valid dari server');
      }
    }
    throw Exception(_parseError(res));
  }

  /* ────── Helper: parsing error ────── */
  String _parseError(http.Response res) {
    try {
      final data = json.decode(res.body);
      if (data is Map && data['message'] != null) return data['message'];
    } catch (_) {}
    if (res.body.isNotEmpty) return res.body;

    switch (res.statusCode) {
      case 400: return 'Data yang dikirim tidak valid';
      case 401: return 'Email atau password salah';
      case 409: return 'Email atau username sudah digunakan';
      case 500: return 'Terjadi kesalahan pada server';
      default : return 'Terjadi kesalahan tidak terduga (${res.statusCode})';
    }
  }
}
