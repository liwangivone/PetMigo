import 'dart:convert';
import 'dart:io';
import 'package:frontend/services/url.dart';
import 'package:http/http.dart' as http;

import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatService {
  final String _base;
  ChatService({String? baseUrl}) : _base = baseUrl ?? kChatAPI;

  /* ───────────── Create Chat ───────────── */
  Future<ChatModel> createChatByIds(String userId, String vetId) async {
    final uri = Uri.parse('$_base/create?user_id=$userId&vet_id=$vetId');
    final res = await http.post(uri);
    _check(res);
    return ChatModel.fromJson(jsonDecode(res.body));
  }

  /* ───────────── Send Message ───────────── */
  Future<MessageModel> sendMessage(String chatId, MessageModel m) async {
    final uri = Uri.parse(
      '$_base/send-message'
      '?chat_id=$chatId'
      '&role=${Uri.encodeComponent(m.role)}'
      '&sender_id=${Uri.encodeComponent(m.senderId)}'
      '&messagetext=${Uri.encodeQueryComponent(m.messagetext)}',
    );
    final res = await http.post(uri);
    _check(res);
    return MessageModel.fromJson(jsonDecode(res.body));
  }

  /* ───────────── Fetch Messages ───────────── */
  Future<List<MessageModel>> fetchMessages(String chatId) async {
    final uri = Uri.parse('$_base/messages?chat_id=$chatId');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});
    _check(res);
    final List data = jsonDecode(res.body) as List;
    return data.map((e) => MessageModel.fromJson(e)).toList();
  }

  /* ───────────── Fetch Chats by User ───────────── */
  Future<List<ChatModel>> fetchChats(String userId) async {
    final uri = Uri.parse('$_base/chats?user_id=$userId');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});
    _check(res);
    final List data = jsonDecode(res.body) as List;
    return data.map((e) => ChatModel.fromJson(e)).toList();
  }

  /* ───────────── Fetch Chats by Role and ID ───────────── */
  Future<List<ChatModel>> getChatsBySender(String role, String id) async {
    final uri = Uri.parse('$_base/by-sender?role=$role&id=$id');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});
    _check(res);
    final List data = jsonDecode(res.body) as List;
    return data.map((e) => ChatModel.fromJson(e)).toList();
  }

  /* ───────────── Error Handling ───────────── */
  void _check(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw HttpException(
        '${res.statusCode} ${res.reasonPhrase}\n${res.body}',
        uri: res.request?.url,
      );
    }
  }
}
