import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/chat_model.dart';
import '../../models/message_model.dart';
import '../../services/chat_service.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService svc;
  ChatBloc(this.svc) : super(ChatInitial()) {
    on<FetchAllChats>(_fetchAll);
    on<FetchAllMessages>(_fetchAllMessages);
    on<CreateChatWithIds>(_createByIds);
    on<SendMessageEvent>(_sendMessage);
  }

  Future<void> _fetchAll(FetchAllChats e, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final chats = await svc.fetchChats(e.userId);
      emit(ChatListLoaded(chats));
    } catch (err) {
      emit(ChatError(err.toString()));
    }
  }

  Future<void> _fetchAllMessages(FetchAllMessages e, Emitter<ChatState> emit) async {
    final firstLoad = state is! ChatLoaded;
    if (!e.silent || firstLoad) {
      emit(ChatLoading());
    }

    try {
      final msgs = await svc.fetchMessages(e.chatId);
      msgs.sort((a, b) => a.sentDate.compareTo(b.sentDate));
      emit(ChatLoaded(ChatModel.simple(id: e.chatId, messages: msgs)));
    } catch (err) {
      emit(ChatError(err.toString()));
    }
  }

  Future<void> _createByIds(CreateChatWithIds e, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final chat = await svc.createChatByIds(e.userId, e.vetId);
      emit(ChatLoaded(chat));
    } catch (err) {
      emit(ChatError(err.toString()));
    }
  }

  Future<void> _sendMessage(SendMessageEvent e, Emitter<ChatState> emit) async {
    if (state is ChatLoaded) {
      final curr = (state as ChatLoaded).chat;
      final list = List<MessageModel>.from(curr.messages)..add(e.message);
      emit(ChatLoaded(ChatModel.simple(id: e.chatId, messages: list)));
    }

    try {
      await svc.sendMessage(e.chatId, e.message);
      add(FetchAllMessages(e.chatId, silent: true));
    } catch (err) {
      emit(ChatError(err.toString()));
    }
  }
}
