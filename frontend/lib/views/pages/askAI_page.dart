part of 'pages.dart';

//Halaman depan
class AskAIWelcome extends StatelessWidget {
  const AskAIWelcome({super.key});

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userid');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('User tidak ditemukan. Silakan login kembali.')),
          );
        }

        final userId = snapshot.data!;

        return BlocProvider(
          create: (context) => ChatbotBloc(repository: ChatbotRepository()),
          child: AskAIWelcomeView(userId: userId),
        );
      },
    );
  }
}

class AskAIWelcomeView extends StatelessWidget {
  final String userId;

  const AskAIWelcomeView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Robot Image
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FD),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/robot_mora.png', 
                  height: 120,
                  width: 120,
                ),
              ),
              const SizedBox(height: 32),
              // Greeting Text
              const Text(
                "Hi there! I'm Mora",
                textAlign: TextAlign.center, 
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              // Description Text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Your smart companion for anything pet-related. "
                  "Ask me anything about your beloved pet and let's find the best care together.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              // Start Chat Button
              SizedBox(
                width: double.infinity,
                child: BlocConsumer<ChatbotBloc, ChatbotState>(
                  listener: (context, state) {
                    if (state is ChatRoomCreated) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ChatbotBloc>(),
                            child: AskAIChatPage(
                              chatRoom: state.chatRoom,
                              userId: userId,
                            ),
                          ),
                        ),
                      );
                    } else if (state is ChatbotError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is ChatbotLoading
                          ? null
                          : () {
                              context.read<ChatbotBloc>().add(CreateChatRoom(userId: userId));
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8A65),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        ),
                        elevation: 0,
                      ),
                      child: state is ChatbotLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Start chat",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // View History Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<ChatbotBloc>().add(LoadChatRooms(userId: userId));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<ChatbotBloc>(),
                          child: ChatHistoryPage(userId: userId),
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                    side: const BorderSide(color: Color(0xFFFF8A65), width: 1.5),
                  ),
                  child: const Text(
                    "View history",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF8A65),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// Chat History Page
class ChatHistoryPage extends StatelessWidget {
  final String userId;

  const ChatHistoryPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Chat History",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocConsumer<ChatbotBloc, ChatbotState>(
        listener: (context, state) {
          if (state is ChatbotError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ChatbotLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF8A65)),
            );
          }

          if (state is ChatRoomsLoaded) {
            if (state.chatRooms.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada riwayat chat.\nMulai chat baru untuk melihat riwayat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 16,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.chatRooms.length,
              itemBuilder: (context, index) {
                final chatRoom = state.chatRooms[index];
                final lastChat = chatRoom.lastChat;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F4FD),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline,
                        color: Color(0xFFFF8A65),
                      ),
                    ),
                    title: Text(
                      chatRoom.judulChat,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: lastChat != null
                        ? Text(
                            lastChat.chat,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Color(0xFF666666)),
                          )
                        : const Text('Tidak ada pesan'),
                    trailing: Text(
                      _formatDate(chatRoom.editedAt),
                      style: const TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 12,
                      ),
                    ),
                    onTap: () {
                      context.read<ChatbotBloc>().add(LoadChatRoomDetail(roomId: chatRoom.id));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ChatbotBloc>(),
                            child: AskAIChatPage(
                              chatRoom: chatRoom,
                              userId: userId,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// Halaman Chat
class AskAIChatPage extends StatefulWidget {
  final AIChatRoom chatRoom;
  final String userId;

  const AskAIChatPage({super.key, required this.chatRoom, required this.userId});

  @override
  State<AskAIChatPage> createState() => _AskAIChatPageState();
}

class _AskAIChatPageState extends State<AskAIChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AIChatRoom currentRoom;

  @override
  void initState() {
    super.initState();
    currentRoom = widget.chatRoom;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _openDrawer(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Menu",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: 0.75,
            child: Material(
              color: Colors.white,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: const Row(
                        children: [
                          Icon(Icons.menu, size: 24),
                          SizedBox(width: 12),
                          Text(
                            "Mora",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // Chat History Sections
                    Expanded(
                      child: BlocBuilder<ChatbotBloc, ChatbotState>(
                        builder: (context, state) {
                          return ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              _buildHistorySection("Current Chat", [currentRoom.judulChat]),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.read<ChatbotBloc>().add(LoadChatRooms(userId: widget.userId));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<ChatbotBloc>(),
                                        child: ChatHistoryPage(userId: widget.userId),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text("View All Chats"),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    // Back to Main Page
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListTile(
                        leading: const Icon(Icons.home_outlined),
                        title: const Text(
                          "Back To Main Page",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          context.go('/dashboard');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  Widget _buildHistorySection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        )),
      ],
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final message = _messageController.text.trim();
      context.read<ChatbotBloc>().add(SendMessage(roomId: currentRoom.id, message: message));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => _openDrawer(context),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4FD),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/robot_mora.png',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                currentRoom.judulChat,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'generate_name',
                child: Text('Generate Name'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete Chat'),
              ),
            ],
            onSelected: (value) {
              if (value == 'generate_name') {
                context.read<ChatbotBloc>().add(GenerateRoomName(roomId: currentRoom.id));
              } else if (value == 'delete') {
                _showDeleteConfirmation();
              }
            },
          ),
        ],
      ),
      body: BlocConsumer<ChatbotBloc, ChatbotState>(
        listener: (context, state) {
          if (state is MessageSent) {
            setState(() {
              currentRoom = state.updatedRoom;
            });
            _scrollToBottom();
          } else if (state is ChatRoomDetailLoaded) {
            setState(() {
              currentRoom = state.chatRoom;
            });
            _scrollToBottom();
          } else if (state is RoomNameGenerated) {
            setState(() {
              currentRoom = state.updatedRoom;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Room name updated: ${state.generatedName}'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ChatRoomDeleted) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (state is ChatbotError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Date Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  _formatDate(currentRoom.editedAt),
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Chat Messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: currentRoom.aiChats.length,
                  itemBuilder: (context, index) {
                    final message = currentRoom.aiChats[index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),
              // Loading indicator when sending message
              if (state is ChatbotSendingMessage)
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Mora is typing...'),
                    ],
                  ),
                ),
              // Message Input
              _buildMessageInput(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(AIChat message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Align(
        alignment: message.isBot ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: message.isBot 
                ? const Color(0xFFF0F0F0)
                : const Color(0xFF2196F3),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            message.chat,
            style: TextStyle(
              color: message.isBot ? const Color(0xFF333333) : Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, ChatbotState state) {
    final bool isLoading = state is ChatbotSendingMessage;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  hintText: "Type here...",
                  hintStyle: TextStyle(color: Color(0xFF999999)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20, 
                    vertical: 12
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: isLoading 
                  ? Colors.grey 
                  : const Color.fromARGB(255, 0, 115, 255),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
              onPressed: isLoading ? null : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: const Text('Are you sure you want to delete this chat room? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ChatbotBloc>().add(DeleteChatRoom(roomId: currentRoom.id));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// Chat Message Model (keeping for backward compatibility)
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}