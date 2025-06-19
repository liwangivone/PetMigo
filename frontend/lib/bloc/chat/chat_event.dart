import '../../models/message_model.dart';

abstract class ChatEvent {}

class FetchAllChats extends ChatEvent {
  final String userId;
  FetchAllChats(this.userId);
}

class FetchAllMessages extends ChatEvent {
  final String chatId;
  final bool silent;
  FetchAllMessages(this.chatId, {this.silent = false});
}

class FetchAllMessagesAll extends ChatEvent {
  final String chatId;
  FetchAllMessagesAll(this.chatId);
}

class CreateChatWithIds extends ChatEvent {
  final String userId;
  final String vetId;
  CreateChatWithIds({required this.userId, required this.vetId});
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final MessageModel message;
  SendMessageEvent(this.chatId, this.message);
}

class FetchChatsByRole extends ChatEvent {
  final String role;
  final String id;
  FetchChatsByRole(this.role, this.id);
}
