import 'package:equatable/equatable.dart';

abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatRooms extends ChatbotEvent {
  final String userId;

  const LoadChatRooms({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class CreateChatRoom extends ChatbotEvent {
  final String userId;

  const CreateChatRoom({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoadChatRoomDetail extends ChatbotEvent {
  final String roomId;

  const LoadChatRoomDetail({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}

class SendMessage extends ChatbotEvent {
  final String roomId;
  final String message;

  const SendMessage({required this.roomId, required this.message});

  @override
  List<Object?> get props => [roomId, message];
}

class RenameChatRoom extends ChatbotEvent {
  final String roomId;
  final String newName;

  const RenameChatRoom({required this.roomId, required this.newName});

  @override
  List<Object?> get props => [roomId, newName];
}

class DeleteChatRoom extends ChatbotEvent {
  final String roomId;

  const DeleteChatRoom({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}

class GenerateRoomName extends ChatbotEvent {
  final String roomId;

  const GenerateRoomName({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}
