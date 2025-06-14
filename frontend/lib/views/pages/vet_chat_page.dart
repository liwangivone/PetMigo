import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';               // ← GoRouter

import 'package:frontend/bloc/chat/chat_bloc.dart';
import 'package:frontend/bloc/chat/chat_event.dart';
import 'package:frontend/bloc/chat/chat_state.dart';
import 'package:frontend/models/chat_model.dart';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/models/vet_model.dart';
import 'package:frontend/services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final VetModel? vet;
  final ChatModel? chat;

  const ChatPage({super.key, this.vet, this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _msgCtrl = TextEditingController();
  final _scroll  = ScrollController();

  late final ChatBloc _bloc;
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();

    if (widget.chat == null || widget.vet == null) {
      // Redirect jika vet/chat null
      Future.microtask(() => context.go('/need-vet'));
      return;
    }

    _bloc = ChatBloc(ChatService())..add(FetchAllMessages(widget.chat!.id));
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 3),
        (_) => _bloc.add(FetchAllMessages(widget.chat!.id, silent: true)));
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scroll.dispose();
    _autoRefreshTimer?.cancel();
    if (widget.chat != null && widget.vet != null) _bloc.close();
    super.dispose();
  }

  void _scrollToBottom() =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.minScrollExtent);
      });

  @override
  Widget build(BuildContext context) {
    if (widget.vet == null || widget.chat == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: _appBar(),
        body: BlocConsumer<ChatBloc, ChatState>(
          listener: (_, __) => _scrollToBottom(),
          builder: (_, s) {
            if (s is ChatLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF7A3D)));
            }
            if (s is ChatError) {
              return Center(
                  child: Text(s.message,
                      style: const TextStyle(color: Colors.red)));
            }
            if (s is ChatLoaded) {
              final msgs = s.chat.messages;
              return Column(
                children: [
                  _dateHeader(),
                  Expanded(
                    child: msgs.isEmpty
                        ? const Center(child: Text('Belum ada pesan'))
                        : ListView.builder(
                            reverse: true,
                            controller: _scroll,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: msgs.length,
                            itemBuilder: (_, i) =>
                                _bubble(msgs[msgs.length - 1 - i]),
                          ),
                  ),
                  _inputBar(context),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  //────────────────────────── COMPONENTS ──────────────────────────
  PreferredSizeWidget _appBar() => AppBar(
        backgroundColor: Colors.white,
        elevation: .5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              size: 18, color: Colors.black),
          onPressed: () => context.go('/need-vet'),          // ← Back OK
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(widget.vet!.imageUrl)),
            const SizedBox(width: 12),
            Text(widget.vet!.name,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      );

  Widget _dateHeader() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child:
            Text('Today', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
      );

  Widget _bubble(MessageModel m) {
    final isUser = m.role.toLowerCase() == 'user';
    final bg = isUser ? const Color(0xFF007AFF) : Colors.white;
    final fg = isUser ? Colors.white : Colors.black87;
    final date = DateFormat('yyyy-MM-dd HH:mm').format(m.sentDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(radius: 16, backgroundImage: NetworkImage(widget.vet!.imageUrl)),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: isUser
                    ? null
                    : [
                        BoxShadow(
                            color: Colors.black.withOpacity(.15),
                            blurRadius: 3,
                            offset: const Offset(0, 1))
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.name,
                      style: TextStyle(
                          fontSize: 12,
                          color: fg.withOpacity(.85),
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(m.messagetext,
                      style: TextStyle(fontSize: 15, color: fg)),
                  const SizedBox(height: 4),
                  Text(date,
                      style: TextStyle(
                          fontSize: 10, color: fg.withOpacity(.75))),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFE5E7EB),
              child: Icon(Icons.person,
                  size: 18, color: Color(0xFF9CA3AF)),
            )
          ],
        ],
      ),
    );
  }

  Widget _inputBar(BuildContext ctx) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border:
              Border(top: BorderSide(color: Color(0xFFE5E7EB), width: .5)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(25)),
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    maxLines: null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF007AFF)),
                onPressed: () async {
                  final txt = _msgCtrl.text.trim();
                  if (txt.isEmpty) return;

                  final prefs = await SharedPreferences.getInstance();
                  final userId = prefs.getString('userid');
                  if (userId == null) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(content: Text('User belum login')));
                    return;
                  }

                  final msg = MessageModel(
                    id: '',
                    name: 'You',
                    role: 'USER',
                    senderId: userId,
                    messagetext: txt,
                    sentDate: DateTime.now(),
                  );

                  _bloc.add(SendMessageEvent(widget.chat!.id, msg));
                  _msgCtrl.clear();
                },
              ),
            ],
          ),
        ),
      );
}
