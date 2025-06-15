import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chatbot_models.dart';

class ChatbotService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/chatbot';

  Future<List<AIChatRoom>> getChatRooms(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rooms/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => AIChatRoom.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('User tidak ditemukan');
      } else {
        throw Exception('Gagal mengambil chat rooms: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting chat rooms: $e');
    }
  }

  Future<AIChatRoom> createChatRoom(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/rooms/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        return AIChatRoom.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('User tidak ditemukan');
      } else {
        throw Exception('Gagal membuat chat room: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating chat room: $e');
    }
  }

  Future<AIChatRoom> getChatRoomDetail(String roomId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rooms/detail/$roomId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return AIChatRoom.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Chat room tidak ditemukan');
      } else {
        throw Exception('Gagal mengambil detail chat room: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting chat room detail: $e');
    }
  }

  Future<String> sendMessage(String roomId, String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/rooms/$roomId/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(ChatbotPromptRequest(prompt: prompt).toJson()),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 404) {
        throw Exception('Chat room tidak ditemukan');
      } else if (response.statusCode == 400) {
        throw Exception(response.body);
      } else {
        throw Exception('Gagal mengirim pesan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  Future<String> renameChatRoom(String roomId, String newName) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/rooms/$roomId/rename'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(RenameRoomRequest(newName: newName).toJson()),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 404) {
        throw Exception('Chat room tidak ditemukan');
      } else {
        throw Exception('Gagal mengubah nama chat room: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error renaming chat room: $e');
    }
  }

  Future<void> deleteChatRoom(String roomId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/rooms/$roomId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Chat room tidak ditemukan');
      } else {
        throw Exception('Gagal menghapus chat room: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting chat room: $e');
    }
  }

  Future<String> generateRoomName(String roomId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/rooms/$roomId/generate-name'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 404) {
        throw Exception('Chat room tidak ditemukan');
      } else {
        throw Exception('Gagal generate nama chat room: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating room name: $e');
    }
  }
}
