class AIChatRoom {
  final String id;
  final String judulChat;
  final DateTime createdAt;
  final DateTime editedAt;
  final List<AIChat> aiChats;
  final String userId;

  AIChatRoom({
    required this.id,
    required this.judulChat,
    required this.createdAt,
    required this.editedAt,
    required this.aiChats,
    required this.userId,
  });

  factory AIChatRoom.fromJson(Map<String, dynamic> json) {
    return AIChatRoom(
      id: json['id'] ?? '',
      judulChat: json['judulChat'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      editedAt: DateTime.parse(json['editedAt'] ?? DateTime.now().toIso8601String()),
      aiChats: (json['aiChats'] as List?)?.map((chat) => AIChat.fromJson(chat)).toList() ?? [],
      userId: json['idUser']?['userid']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judulChat': judulChat,
      'createdAt': createdAt.toIso8601String(),
      'editedAt': editedAt.toIso8601String(),
      'aiChats': aiChats.map((chat) => chat.toJson()).toList(),
      'userId': userId,
    };
  }

  AIChat? get lastChat {
    if (aiChats.isEmpty) return null;
    return aiChats.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);
  }
}

class AIChat {
  final String id;
  final String chat;
  final bool isBot;
  final DateTime createdAt;
  final String chatRoomId;

  AIChat({
    required this.id,
    required this.chat,
    required this.isBot,
    required this.createdAt,
    required this.chatRoomId,
  });

  factory AIChat.fromJson(Map<String, dynamic> json) {
    return AIChat(
      id: json['id'] ?? '',
      chat: json['chat'] ?? '',
      isBot: json['isBot'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      chatRoomId: json['idChatRoom']?['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat': chat,
      'isBot': isBot,
      'createdAt': createdAt.toIso8601String(),
      'chatRoomId': chatRoomId,
    };
  }
}

class ChatbotPromptRequest {
  final String prompt;

  ChatbotPromptRequest({required this.prompt});

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
    };
  }
}

class RenameRoomRequest {
  final String newName;

  RenameRoomRequest({required this.newName});

  Map<String, dynamic> toJson() {
    return {
      'newName': newName,
    };
  }
}
