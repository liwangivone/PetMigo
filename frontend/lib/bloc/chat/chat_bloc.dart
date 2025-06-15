import 'package:flutter/foundation.dart';          // debugPrint
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
    debugPrint('[ChatBloc] FetchAllChats → user_id=${e.userId}');
    emit(ChatLoading());
    try {
      final chats = await svc.fetchChats(e.userId);
      debugPrint('[ChatBloc] FetchAllChats SUCCESS → total=${chats.length}');
      emit(ChatListLoaded(chats));
    } catch (err) {
      debugPrint('[ChatBloc] FetchAllChats ERROR: $err');
      emit(ChatError(err.toString()));
    }
  }

  Future<void> _fetchAllMessages(FetchAllMessages e, Emitter<ChatState> emit) async {
    debugPrint('[ChatBloc] FetchAllMessages → chat_id=${e.chatId}, silent=${e.silent}');
    final firstLoad = state is! ChatLoaded;
    if (!e.silent || firstLoad) {
      emit(ChatLoading());                     // tampilkan spinner hanya bila perlu
    }

    try {
      final msgs = await svc.fetchMessages(e.chatId);         // 1. ambil data
      msgs.sort((a, b) => a.sentDate.compareTo(b.sentDate));  // 2. urutkan

      for (final m in msgs) debugPrint('📨 ${m.messagetext}'); // 3. debug
      debugPrint('[ChatBloc] SUCCESS total=${msgs.length}');

      emit(ChatLoaded(ChatModel.simple(id: e.chatId, messages: msgs))); // 4. emit
    } catch (err) {
      debugPrint('[ChatBloc] ERROR: $err');
      emit(ChatError(err.toString()));
    }
  }

  Future<void> _createByIds(CreateChatWithIds e, Emitter<ChatState> emit) async {
    debugPrint('[ChatBloc] CreateChatWithIds → user=${e.userId}, vet=${e.vetId}');
    emit(ChatLoading());
    try {
      final chat = await svc.createChatByIds(e.userId, e.vetId);
      debugPrint('[ChatBloc] CreateChatWithIds SUCCESS → chat_id=${chat.id}');
      emit(ChatLoaded(chat));
    } catch (err) {
      debugPrint('[ChatBloc] CreateChatWithIds ERROR: $err');
      emit(ChatError(err.toString()));
    }
  }

  Future<void> _sendMessage(SendMessageEvent e, Emitter<ChatState> emit) async {
    debugPrint('[ChatBloc] SendMessageEvent → chat_id=${e.chatId}');
    if (state is ChatLoaded) {
      final curr = (state as ChatLoaded).chat;
      final list = List<MessageModel>.from(curr.messages)..add(e.message);
      emit(ChatLoaded(ChatModel.simple(id: e.chatId, messages: list)));
    }

    try {
      await svc.sendMessage(e.chatId, e.message);
      debugPrint('[ChatBloc] SendMessageEvent SUCCESS');
      add(FetchAllMessages(e.chatId, silent: true));       // muat ulang SENYAP
    } catch (err) {
      debugPrint('[ChatBloc] SendMessageEvent ERROR: $err');
      emit(ChatError(err.toString()));
    }
  }
}
