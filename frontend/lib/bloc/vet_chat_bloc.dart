import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/vet_models.dart';

abstract class ChatEvent {}

class LoadChatEvent extends ChatEvent {
  final VetModel vet;
  LoadChatEvent(this.vet);
}

class SendMessageEvent extends ChatEvent {
  final String message;
  SendMessageEvent(this.message);
}

class ReceiveMessageEvent extends ChatEvent {
  final String message;
  ReceiveMessageEvent(this.message);
}

// chat_state.dart
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final ChatRoom chatRoom;
  ChatLoaded(this.chatRoom);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<LoadChatEvent>(_onLoadChat);
    on<SendMessageEvent>(_onSendMessage);
    on<ReceiveMessageEvent>(_onReceiveMessage);
  }

  void _onLoadChat(LoadChatEvent event, Emitter<ChatState> emit) {
    emit(ChatLoading());
    
    // Simulate loading chat room with initial messages
    final chatRoom = ChatRoom(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      vet: event.vet,
      messages: [
        // Initial user message
        VetMessage(
          id: '1',
          message: 'Hello my cat is not feeling well. He vomits three times already today, what should I do?',
          isFromUser: true,
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        // Vet response
        VetMessage(
          id: '2',
          message: 'Oh no! I\'m also sad to hear that your cat is unwell. Let\'s help her to feel better. Can you tell me all her detailed symptoms?',
          isFromUser: false,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ],
    );
    
    emit(ChatLoaded(chatRoom));
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final newMessage = VetMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: event.message,
        isFromUser: true,
        timestamp: DateTime.now(),
      );

      final updatedMessages = List<VetMessage>.from(currentState.chatRoom.messages)
        ..add(newMessage);

      final updatedChatRoom = currentState.chatRoom.copyWith(
        messages: updatedMessages,
      );

      emit(ChatLoaded(updatedChatRoom));

      // Simulate vet response after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        add(ReceiveMessageEvent(_generateVetResponse(event.message)));
      });
    }
  }

  void _onReceiveMessage(ReceiveMessageEvent event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final newMessage = VetMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: event.message,
        isFromUser: false,
        timestamp: DateTime.now(),
      );

      final updatedMessages = List<VetMessage>.from(currentState.chatRoom.messages)
        ..add(newMessage);

      final updatedChatRoom = currentState.chatRoom.copyWith(
        messages: updatedMessages,
      );

      emit(ChatLoaded(updatedChatRoom));
    }
  }

  String _generateVetResponse(String userMessage) {
    // Simple response generator
    final responses = [
      'I understand your concern. Can you tell me more about the symptoms?',
      'That sounds concerning. How long has this been going on?',
      'Thank you for the information. Let me help you with that.',
      'I recommend bringing your pet in for a check-up. Would that work for you?',
    ];
    return responses[DateTime.now().millisecondsSinceEpoch % responses.length];
  }
}