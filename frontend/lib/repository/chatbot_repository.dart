import '../models/chatbot_models.dart';
import '../services/chatbot_service.dart';

class ChatbotRepository {
  final ChatbotService _chatbotService;

  ChatbotRepository({ChatbotService? chatbotService}) 
      : _chatbotService = chatbotService ?? ChatbotService();

  Future<List<AIChatRoom>> getChatRooms(String userId) async {
    try {
      return await _chatbotService.getChatRooms(userId);
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      throw Exception(errorMessage);
    }
  }

  Future<AIChatRoom> createChatRoom(String userId) async {
    try {
      return await _chatbotService.createChatRoom(userId);
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      throw Exception(errorMessage);
    }
  }

  Future<AIChatRoom> getChatRoomDetail(String roomId) async {
    try {
      return await _chatbotService.getChatRoomDetail(roomId);
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      throw Exception(errorMessage);
    }
  }

  Future<String> sendMessage(String roomId, String prompt) async {
    try {
      if (prompt.trim().isEmpty) {
        throw Exception('Pesan tidak boleh kosong');
      }
      return await _chatbotService.sendMessage(roomId, prompt.trim());
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      throw Exception(errorMessage);
    }
  }

  Future<String> renameChatRoom(String roomId, String newName) async {
    try {
      if (newName.trim().isEmpty) {
        throw Exception('Nama chat room tidak boleh kosong');
      }
      return await _chatbotService.renameChatRoom(roomId, newName.trim());
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      throw Exception(errorMessage);
    }
  }

  Future<void> deleteChatRoom(String roomId) async {
    try {
      return await _chatbotService.deleteChatRoom(roomId);
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      throw Exception(errorMessage);
    }
  }

  Future<String> generateRoomName(String roomId) async {
    try {
      return await _chatbotService.generateRoomName(roomId);
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      throw Exception(errorMessage);
    }
  }
}
