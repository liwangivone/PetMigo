import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String baseUrl;
  UserService({this.baseUrl = 'http://localhost:8080/api/users'});


  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/profiles/$userId'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        print('Response data: $data'); // optional debug log

        final prefs = await SharedPreferences.getInstance();

        // hanya simpan jika nilai dari server tidak null
        if (data['id'] != null) await prefs.setString('userid', data['id']);
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

      // fallback baca dari local jika gagal koneksi atau error lainnya
      return {
        'id': prefs.getString('userid') ?? '',
        'name': prefs.getString('name') ?? '',
        'email': prefs.getString('email') ?? '',
        'phonenumber': prefs.getString('phonenumber') ?? '',
        'profileImageUrl': prefs.getString('profileImageUrl') ?? '',
        'isPremium': prefs.getBool('isPremium') ?? false,
      };
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(dynamic user) async {
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
    // Implement API for profile image update if available
    // For now, just simulate
    return getUserProfile(userId);
  }

  Future<void> logout() async {
    // Implement logout if needed
    return;
  }
}
