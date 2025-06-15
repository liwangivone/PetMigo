import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/chatbot_repository.dart';
import '../../models/chatbot_models.dart';
import 'chatbot_event.dart';
import 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ChatbotRepository _repository;

  ChatbotBloc({ChatbotRepository? repository})
      : _repository = repository ?? ChatbotRepository(),
        super(ChatbotInitial()) {
    
    on<LoadChatRooms>(_onLoadChatRooms);
    on<CreateChatRoom>(_onCreateChatRoom);
    on<LoadChatRoomDetail>(_onLoadChatRoomDetail);
    on<SendMessage>(_onSendMessage);
    on<RenameChatRoom>(_onRenameChatRoom);
    on<DeleteChatRoom>(_onDeleteChatRoom);
    on<GenerateRoomName>(_onGenerateRoomName);
  }

  Future<void> _onLoadChatRooms(LoadChatRooms event, Emitter<ChatbotState> emit) async {
    emit(ChatbotLoading());
    try {
      final chatRooms = await _repository.getChatRooms(event.userId);
      emit(ChatRoomsLoaded(chatRooms: chatRooms));
    } catch (e) {
      emit(ChatbotError(message: e.toString()));
    }
  }

  Future<void> _onCreateChatRoom(CreateChatRoom event, Emitter<ChatbotState> emit) async {
    emit(ChatbotLoading());
    try {
      final newRoom = await _repository.createChatRoom(event.userId);
      emit(ChatRoomCreated(chatRoom: newRoom));
    } catch (e) {
      emit(ChatbotError(message: e.toString()));
    }
  }

  Future<void> _onLoadChatRoomDetail(LoadChatRoomDetail event, Emitter<ChatbotState> emit) async {
    emit(ChatbotLoading());
    try {
      final chatRoom = await _repository.getChatRoomDetail(event.roomId);
      emit(ChatRoomDetailLoaded(chatRoom: chatRoom));
    } catch (e) {
      emit(ChatbotError(message: e.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatbotState> emit) async {
    try {
      // Get current room state
      AIChatRoom? currentRoom;
      if (state is ChatRoomDetailLoaded) {
        currentRoom = (state as ChatRoomDetailLoaded).chatRoom;
      } else if (state is MessageSent) {
        currentRoom = (state as MessageSent).updatedRoom;
      }

      if (currentRoom == null) {
        emit(const ChatbotError(message: 'Chat room tidak ditemukan'));
        return;
      }

      emit(ChatbotSendingMessage(currentRoom: currentRoom));

      final botResponse = await _repository.sendMessage(event.roomId, event.message);
      
      // Get updated room detail after sending message
      final updatedRoom = await _repository.getChatRoomDetail(event.roomId);
      
      emit(MessageSent(updatedRoom: updatedRoom, botResponse: botResponse));
    } catch (e) {
      AIChatRoom? currentRoom;
      if (state is ChatbotSendingMessage) {
        currentRoom = (state as ChatbotSendingMessage).currentRoom;
      }
      emit(ChatbotError(message: e.toString(), currentRoom: currentRoom));
    }
  }

  Future<void> _onRenameChatRoom(RenameChatRoom event, Emitter<ChatbotState> emit) async {
    try {
      final newName = await _repository.renameChatRoom(event.roomId, event.newName);
      final updatedRoom = await _repository.getChatRoomDetail(event.roomId);
      emit(ChatRoomRenamed(newName: newName, updatedRoom: updatedRoom));
    } catch (e) {
      emit(ChatbotError(message: e.toString()));
    }
  }

  Future<void> _onDeleteChatRoom(DeleteChatRoom event, Emitter<ChatbotState> emit) async {
    try {
      await _repository.deleteChatRoom(event.roomId);
      emit(ChatRoomDeleted());
    } catch (e) {
      emit(ChatbotError(message: e.toString()));
    }
  }

  Future<void> _onGenerateRoomName(GenerateRoomName event, Emitter<ChatbotState> emit) async {
    try {
      final generatedName = await _repository.generateRoomName(event.roomId);
      final updatedRoom = await _repository.getChatRoomDetail(event.roomId);
      emit(RoomNameGenerated(generatedName: generatedName, updatedRoom: updatedRoom));
    } catch (e) {
      emit(ChatbotError(message: e.toString()));
    }
  }
}
