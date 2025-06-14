import 'message_model.dart';

class ChatModel {
  final String id;
  final DateTime timeCreated;
  final String status;
  final String userId;
  final String vetId;
  final List<MessageModel> messages;

  /* konstruktor lengkap */
  ChatModel({
    required this.id,
    required this.timeCreated,
    required this.status,
    required this.userId,
    required this.vetId,
    required this.messages,
  });

  /* konstruktor ringkas – cukup id & messages  */
  ChatModel.simple({
    required String id,
    required List<MessageModel> messages,
  }) : this(
          id: id,
          timeCreated: DateTime.now(),
          status: '',
          userId: '',
          vetId: '',
          messages: messages,
        );

  factory ChatModel.fromJson(Map<String, dynamic> j) => ChatModel(
        id: j['chat_id']?.toString() ?? '',
        timeCreated: DateTime.parse(
            j['timecreated'] ?? DateTime.now().toIso8601String()),
        status: j['status'] ?? '',
        userId: j['user']?['id']?.toString() ??
            j['user_id']?.toString() ??
            '',
        vetId: j['vet']?['id']?.toString() ??
            j['vet_id']?.toString() ??
            '',
        messages: (j['messages'] as List<dynamic>? ?? [])
            .map((e) => MessageModel.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'chat_id': id,
        'timecreated': timeCreated.toIso8601String(),
        'status': status,
        'user_id': userId,
        'vet_id': vetId,
        'messages': messages.map((e) => e.toJson()).toList(),
      };
}
