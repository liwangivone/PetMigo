import '../services/chat_service.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRepository {
  final ChatService svc;
  const ChatRepository(this.svc);

  Future<ChatModel> createChatByIds(String userId, String vetId) =>
      svc.createChatByIds(userId, vetId);

  Future<List<ChatModel>> fetchChats(String userId) =>
      svc.fetchChats(userId);

  Future<List<MessageModel>> fetchMessages(String chatId) =>
      svc.fetchMessages(chatId);

  Future<MessageModel> sendMessage(String chatId, MessageModel m) =>
      svc.sendMessage(chatId, m);
}
