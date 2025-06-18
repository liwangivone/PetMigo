import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/bloc/chat/chat_bloc.dart';
import 'package:frontend/bloc/chat/chat_event.dart';
import 'package:frontend/bloc/chat/chat_state.dart';
import 'package:frontend/models/chat_model.dart';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/models/vet_model.dart';
import 'package:frontend/services/chat_service.dart';

class VetChatPage extends StatefulWidget {
  final VetModel? vet;
  final ChatModel? chat;
  final bool isVet;

  const VetChatPage({
    super.key, 
    this.vet, 
    this.chat,
    required this.isVet,
  });

  @override
  State<VetChatPage> createState() => _VetChatPageState();
}

class _VetChatPageState extends State<VetChatPage> {
  final _msgCtrl = TextEditingController();
  final _scroll = ScrollController();

  late final ChatBloc _bloc;
  Timer? _autoRefreshTimer;
  bool _otherPartyOnline = false;
  DateTime? _lastSeen;

  @override
  void initState() {
    super.initState();

    if (widget.chat == null && widget.vet == null) {
      Future.microtask(() => context.go(widget.isVet ? '/vet/home' : '/need-vet'));
      return;
    }

    if (widget.chat != null) {
      _bloc = ChatBloc(ChatService())..add(FetchAllMessages(widget.chat!.id));
      _autoRefreshTimer = Timer.periodic(
        const Duration(seconds: 3),
        (_) {
          _bloc.add(FetchAllMessages(widget.chat!.id, silent: true));
          _updateStatus();
        },
      );
      
      // Initial status setup
      _updateStatus();
    } else if (widget.vet != null) {
      // If we have vet data directly (new chat)
      _otherPartyOnline = widget.vet!.status == VetStatus.online;
      _lastSeen = DateTime.now(); // In real app, get from API
    }
  }

  void _updateStatus() {
    if (widget.chat == null) return;

    final otherParty = widget.isVet ? widget.chat!.user : widget.chat!.vet;
    
    if (otherParty == null) return;

    setState(() {
      if (widget.isVet) {
        // For vet viewing user status (simplified - in real app use API)
        _otherPartyOnline = DateTime.now().minute % 2 == 0; // Simulate status change
        _lastSeen = _otherPartyOnline ? null : DateTime.now().subtract(const Duration(minutes: 5));
      } else {
        // For user viewing vet status
        if (widget.chat?.vet != null) {
          _otherPartyOnline = widget.chat!.vet!.status == VetStatus.online;
          _lastSeen = _otherPartyOnline ? null : DateTime.now().subtract(const Duration(minutes: 10));
        } else if (widget.vet != null) {
          _otherPartyOnline = widget.vet!.status == VetStatus.online;
          _lastSeen = _otherPartyOnline ? null : DateTime.now().subtract(const Duration(minutes: 15));
        }
      }
    });
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scroll.dispose();
    _autoRefreshTimer?.cancel();
    if (widget.chat != null || widget.vet != null) _bloc.close();
    super.dispose();
  }

  void _scrollToBottom() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.minScrollExtent);
      });

  @override
  Widget build(BuildContext context) {
    if (widget.vet == null && widget.chat == null) {
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
                  _statusIndicator(),
                  Expanded(
                    child: msgs.isEmpty
                        ? const Center(child: Text('No messages yet'))
                        : ListView.builder(
                            reverse: true,
                            controller: _scroll,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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

  Widget _statusIndicator() {
    final statusText = _otherPartyOnline 
        ? 'Online' 
        : _lastSeen != null 
            ? 'Terakhir dilihat ${DateFormat('HH:mm').format(_lastSeen!)}'
            : 'Offline';
    
    final statusColor = _otherPartyOnline ? Colors.green : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_otherPartyOnline) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar() => AppBar(
        backgroundColor: Colors.white,
        elevation: .5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
          onPressed: () => context.go(widget.isVet ? '/vet/home' : '/dashboard'),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[200],
              child: Icon(
                widget.isVet ? Icons.medical_services : Icons.pets,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isVet 
                    ? widget.chat?.user?.name ?? 'Pet Owner'
                    : widget.vet?.name ?? widget.chat?.vet?.name ?? 'Vet',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  _otherPartyOnline 
                    ? 'Online'
                    : _lastSeen != null
                        ? 'Offline - Terakhir dilihat ${DateFormat('HH:mm').format(_lastSeen!)}'
                        : 'Offline',
                  style: TextStyle(
                    fontSize: 12,
                    color: _otherPartyOnline ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _dateHeader() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text('Today', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
      );

  Widget _bubble(MessageModel m) {
    final isCurrentUser = widget.isVet 
      ? m.role.toLowerCase() == 'vet'
      : m.role.toLowerCase() == 'user';
    
    final bg = isCurrentUser ? const Color(0xFF007AFF) : Colors.white;
    final fg = isCurrentUser ? Colors.white : Colors.black87;
    final date = DateFormat('yyyy-MM-dd HH:mm').format(m.sentDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[200],
              child: Icon(
                widget.isVet ? Icons.pets : Icons.medical_services,
                color: Colors.grey[600],
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isCurrentUser ? 20 : 4),
                  bottomRight: Radius.circular(isCurrentUser ? 4 : 20),
                ),
                boxShadow: isCurrentUser
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
          if (isCurrentUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFE5E7EB),
              child: Icon(
                widget.isVet ? Icons.medical_services : Icons.person,
                size: 18,
                color: const Color(0xFF9CA3AF),
              ),
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
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: .5)),
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
                      hintText: 'Type a message...',
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
                  final id = widget.isVet 
                    ? prefs.getString('vetid')
                    : prefs.getString('userid');
                  
                  if (id == null) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(content: Text('User not logged in')));
                    return;
                  }

                  final msg = MessageModel(
                    id: '',
                    name: widget.isVet 
                      ? 'Dr. ${widget.chat?.vet?.name ?? 'Vet'}'
                      : widget.chat?.user?.name ?? 'You',
                    role: widget.isVet ? 'VET' : 'USER',
                    senderId: id,
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