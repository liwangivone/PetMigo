import 'package:frontend/models/user_model.dart';
import 'package:frontend/models/vet_model.dart';
import 'message_model.dart';

class ChatModel {
  final String id;
  final DateTime timeCreated;
  final String status;
  final User? user;
  final String userId;
  final VetModel? vet;
  final String vetId;
  final List<MessageModel> messages;

  ChatModel({
    required this.id,
    required this.timeCreated,
    required this.status,
    required this.userId,
    required this.vetId,
    required this.messages,
    this.user,
    this.vet,
  });

  ChatModel.simple({
    required this.id,
    required this.messages,
  })  : timeCreated = DateTime.now(),
        status = 'active',
        userId = '',
        vetId = '',
        user = null,
        vet = null;

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    try {
      return ChatModel(
        id: _parseString(json['chat_id']),
        timeCreated: _parseDateTime(json['timecreated']),
        status: _parseString(json['status'], defaultValue: 'active'),
        userId: _parseString(json['user_id'] ?? json['user']?['userid']),
        vetId: _parseString(json['vet_id'] ?? json['vet']?['vetid']),
        messages: _parseMessages(json['messages']),
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        vet: json['vet'] != null ? VetModel.fromJson(json['vet']) : null,
      );
    } catch (e) {
      throw FormatException('Failed to parse ChatModel: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'chat_id': id,
      'timecreated': timeCreated.toIso8601String(),
      'status': status,
      'user_id': userId,
      'vet_id': vetId,
      'messages': messages.map((m) => m.toJson()).toList(),
      if (user != null) 'user': user!.toJson(),
      if (vet != null) 'vet': vet!.toJson(),
    };
  }

  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  static List<MessageModel> _parseMessages(dynamic messages) {
    if (messages == null || messages is! List) return [];
    return messages
        .map((m) => MessageModel.fromJson(m))
        .whereType<MessageModel>()
        .toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          timeCreated == other.timeCreated &&
          status == other.status &&
          userId == other.userId &&
          vetId == other.vetId;

  @override
  int get hashCode =>
      id.hashCode ^
      timeCreated.hashCode ^
      status.hashCode ^
      userId.hashCode ^
      vetId.hashCode;

  ChatModel copyWith({
    String? id,
    DateTime? timeCreated,
    String? status,
    User? user,
    String? userId,
    VetModel? vet,
    String? vetId,
    List<MessageModel>? messages,
  }) {
    return ChatModel(
      id: id ?? this.id,
      timeCreated: timeCreated ?? this.timeCreated,
      status: status ?? this.status,
      user: user ?? this.user,
      userId: userId ?? this.userId,
      vet: vet ?? this.vet,
      vetId: vetId ?? this.vetId,
      messages: messages ?? this.messages,
    );
  }
}
