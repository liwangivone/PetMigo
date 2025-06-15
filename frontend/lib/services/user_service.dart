import 'dart:convert';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/services/url.dart';

class UserService {
  final String baseUrl;
  UserService({this.baseUrl = kUserAPI});

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/profiles/$userId'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final prefs = await SharedPreferences.getInstance();
        if (data['uid'] != null) await prefs.setString('uid', data['uid']);
        if (data['name'] != null) await prefs.setString('name', data['name']);
        if (data['email'] != null) await prefs.setString('email', data['email']);
        if (data['phonenumber'] != null) await prefs.setString('phonenumber', data['phonenumber']);
        if (data['profileImageUrl'] != null) {
          await prefs.setString('profileImageUrl', data['profileImageUrl']);
        }
        if (data['isPremium'] != null) {
          await prefs.setBool('isPremium', data['isPremium']);
        }

        return data;
      }

      throw Exception('Server responded ${response.statusCode}');
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();

      return {
        'uid': prefs.getString('uid') ?? '',
        'name': prefs.getString('name') ?? '',
        'email': prefs.getString('email') ?? '',
        'phonenumber': prefs.getString('phonenumber') ?? '',
        'profileImageUrl': prefs.getString('profileImageUrl') ?? '',
        'isPremium': prefs.getBool('isPremium') ?? false,
      };
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userid');

    if (userId == null) {
      throw Exception('User ID not found in local storage');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/$userId/update'),
      body: {
        'name': user.name,
        'email': user.email,
        'phonenumber': user.phone,
        'password': user.password,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    throw Exception('Failed to update user profile');
  }

  Future<Map<String, dynamic>> updateProfileImage(String userId, String imageUrl) async {
    // Simulasi: ganti jika sudah punya endpoint asli
    return getUserProfile(userId);
  }
}
