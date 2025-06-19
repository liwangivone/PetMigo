import '../services/chat_service.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRepository {
  final ChatService _service;

  const ChatRepository(this._service);

  /// Membuat chat antara user dan vet berdasarkan ID mereka
  Future<ChatModel> createChatByIds(String userId, String vetId) {
    return _service.createChatByIds(userId, vetId);
  }

  /// Mengambil semua chat berdasarkan user ID
  Future<List<ChatModel>> fetchChats(String userId) {
    return _service.fetchChats(userId);
  }

  /// Mengambil semua pesan berdasarkan chat ID
  Future<List<MessageModel>> fetchMessages(String chatId) {
    return _service.fetchMessages(chatId);
  }

  /// Mengirim pesan ke dalam chat
  Future<MessageModel> sendMessage(String chatId, MessageModel message) {
    return _service.sendMessage(chatId, message);
  }

  /// Mengambil semua chat berdasarkan peran (role) dan ID (user atau vet)
  Future<List<ChatModel>> getChatsBySender(String role, String id) {
    return _service.getChatsBySender(role, id);
  }
  
}
