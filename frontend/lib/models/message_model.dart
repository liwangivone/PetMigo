class MessageModel {
  final String id;
  final String name;        // nama pengirim
  final String role;        // "USER" | "VET"
  final String senderId;
  final String messagetext;
  final DateTime sentDate;

  const MessageModel({
    required this.id,
    required this.name,
    required this.role,
    required this.senderId,
    required this.messagetext,
    required this.sentDate,
  });

  /* convenience agar m.text tetap jalan */
  String get text => messagetext;

  /// ──────────── PARSING ────────────
  factory MessageModel.fromJson(Map<String, dynamic> j) => MessageModel(
        id: j['message_id']?.toString()               // 🔰 fallback ke 'id'
            ?? j['id']?.toString()
            ?? '',
        name: j['name'] ?? '',
        role: j['role'] ?? '',
        senderId: j['sender_id']?.toString()
            ?? j['senderId']?.toString()
            ?? '',
        messagetext: j['messagetext']                 // 🔰 fallback
            ?? j['messageText']
            ?? j['message']                           // 🔥 FIX: antisipasi "message"
            ?? j['text']
            ?? '',
        sentDate: DateTime.parse(
            j['sentdate']
                ?? j['sentDate']
                ?? DateTime.now().toIso8601String()),
      );

  Map<String, dynamic> toJson() => {
        'message_id': id,
        'name': name,
        'role': role,
        'sender_id': senderId,
        'messagetext': messagetext,
        'sentdate': sentDate.toIso8601String(),
      };
}
