  import '../../models/chat_model.dart';

  abstract class ChatState {}

  class ChatInitial extends ChatState {}
  class ChatLoading extends ChatState {}
  class ChatError extends ChatState {
    final String message;
    ChatError(this.message);
  }
  class ChatListLoaded extends ChatState {
    final List<ChatModel> chats;
    ChatListLoaded(this.chats);
  }
  class ChatLoaded extends ChatState {
    final ChatModel chat;
    ChatLoaded(this.chat);
  }
