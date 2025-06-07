import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl;
  UserService({this.baseUrl = 'http://localhost:8080/api/users'});

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/profiles/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to fetch user profile');
  }

  Future<Map<String, dynamic>> updateUserProfile(dynamic user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${user.id}/update'),
      body: {
        'name': user.name,
        'email': user.email,
        'phonenumber': user.phone,
        // Add password if needed
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
