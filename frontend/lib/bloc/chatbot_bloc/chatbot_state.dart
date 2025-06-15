import 'package:equatable/equatable.dart';
import '../../models/chatbot_models.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object?> get props => [];
}

class ChatbotInitial extends ChatbotState {}

class ChatbotLoading extends ChatbotState {}

class ChatbotSendingMessage extends ChatbotState {
  final AIChatRoom currentRoom;

  const ChatbotSendingMessage({required this.currentRoom});

  @override
  List<Object?> get props => [currentRoom];
}

class ChatRoomsLoaded extends ChatbotState {
  final List<AIChatRoom> chatRooms;

  const ChatRoomsLoaded({required this.chatRooms});

  @override
  List<Object?> get props => [chatRooms];
}

class ChatRoomDetailLoaded extends ChatbotState {
  final AIChatRoom chatRoom;

  const ChatRoomDetailLoaded({required this.chatRoom});

  @override
  List<Object?> get props => [chatRoom];
}

class ChatRoomCreated extends ChatbotState {
  final AIChatRoom chatRoom;

  const ChatRoomCreated({required this.chatRoom});

  @override
  List<Object?> get props => [chatRoom];
}

class MessageSent extends ChatbotState {
  final AIChatRoom updatedRoom;
  final String botResponse;

  const MessageSent({required this.updatedRoom, required this.botResponse});

  @override
  List<Object?> get props => [updatedRoom, botResponse];
}

class ChatRoomRenamed extends ChatbotState {
  final String newName;
  final AIChatRoom updatedRoom;

  const ChatRoomRenamed({required this.newName, required this.updatedRoom});

  @override
  List<Object?> get props => [newName, updatedRoom];
}

class ChatRoomDeleted extends ChatbotState {}

class RoomNameGenerated extends ChatbotState {
  final String generatedName;
  final AIChatRoom updatedRoom;

  const RoomNameGenerated({required this.generatedName, required this.updatedRoom});

  @override
  List<Object?> get props => [generatedName, updatedRoom];
}

class ChatbotError extends ChatbotState {
  final String message;
  final AIChatRoom? currentRoom;

  const ChatbotError({required this.message, this.currentRoom});

  @override
  List<Object?> get props => [message, currentRoom];
}
