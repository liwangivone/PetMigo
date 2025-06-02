class VetModel {
  final String name;
  final String clinic;
  final String experience;
  final String imageUrl;

  VetModel({
    required this.name,
    required this.clinic,
    required this.experience,
    required this.imageUrl,
  });
}

class VetMessage {
  final String _id;
  final String _message;
  final bool _isFromUser;
  final DateTime _timestamp;

  VetMessage({
    required String id,
    required String message,
    required bool isFromUser,
    required DateTime timestamp,
  }) : _id = id,
       _message = message,
       _isFromUser = isFromUser,
       _timestamp = timestamp;

  // Getters
  String get id => _id;
  String get message => _message;
  bool get isFromUser => _isFromUser;
  DateTime get timestamp => _timestamp;
}

class ChatRoom {
  final String id;
  final VetModel vet;
  final List<VetMessage> messages;

  ChatRoom({
    required this.id,
    required this.vet,
    required this.messages,
  });

  ChatRoom copyWith({
    String? id,
    VetModel? vet,
    List<VetMessage>? messages,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      vet: vet ?? this.vet,
      messages: messages ?? this.messages,
    );
  }
}