part of 'pages.dart';

//Halaman depan
class AskAIWelcome extends StatelessWidget {
  const AskAIWelcome({super.key});

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
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AskAIChatPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8A65),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Start chat",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // View History Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Handle view history
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

// Halaman Chat
class AskAIChatPage extends StatefulWidget {
  const AskAIChatPage({super.key});

  @override
  State<AskAIChatPage> createState() => _AskAIChatPageState();
}

class _AskAIChatPageState extends State<AskAIChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "I think my cat is not feeling well, he vomits three times already today, what should I do?",
      isUser: true,
      timestamp: DateTime.now(),
    ),
    ChatMessage(
      text: "Oh no! I'm also sad to hear that your cat is unwell. Let's help her to feel better. Can you tell me all her detailed symptoms?",
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];
  
  bool _isTyping = false;
  final ScrollController _scrollController = ScrollController();
  void _openDrawer(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Chat History",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 1.0,
            child: Material(
              color: Colors.white,
              elevation: 16,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header dengan close button
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
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
                          const Expanded(
                            child: Text(
                              "Chat History",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Color(0xFF666666)),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    
                    // New Chat Button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Start new chat - clear messages
                            setState(() {
                              _messages.clear();
                            });
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("New Chat"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8A65),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Chat History List
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),                        children: [
                          _buildHistorySection("Today", [
                            _buildChatHistoryItem(
                              title: "My cat is not feeling well",
                              time: "2:30 PM",
                              onTap: () => _loadChatHistory("My cat is not feeling well"),
                            ),
                            _buildChatHistoryItem(
                              title: "How to handle pet allergies",
                              time: "1:15 PM",
                              onTap: () => _loadChatHistory("How to handle pet allergies"),
                            ),
                          ]),
                          const SizedBox(height: 24),
                          _buildHistorySection("Yesterday", [
                            _buildChatHistoryItem(
                              title: "Potty training 5 month old dog",
                              time: "4:20 PM",
                              onTap: () => _loadChatHistory("Potty training 5 month old dog"),
                            ),
                            _buildChatHistoryItem(
                              title: "Best food for senior cats",
                              time: "2:45 PM",
                              onTap: () => _loadChatHistory("Best food for senior cats"),
                            ),
                          ]),
                          const SizedBox(height: 24),
                          _buildHistorySection("Previous", [
                            _buildChatHistoryItem(
                              title: "Dog vaccination schedule",
                              time: "Jun 15",
                              onTap: () => _loadChatHistory("Dog vaccination schedule"),
                            ),
                            _buildChatHistoryItem(
                              title: "Cat behavior problems",
                              time: "Jun 14",
                              onTap: () => _loadChatHistory("Cat behavior problems"),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    
                    // Footer Actions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.settings_outlined, color: Color(0xFF666666)),
                            title: const Text(
                              "Settings",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              // Handle settings
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.home_outlined, color: Color(0xFF666666)),
                            title: const Text(
                              "Back to Main Page",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              context.go('/dashboard');
                            },
                          ),
                        ],
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
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );  }
  void _loadChatHistory(String chatTitle) {
    Navigator.of(context).pop();
    
    // Simulate loading chat history based on title
    setState(() {
      _messages.clear();
      _isTyping = false;
      
      // Add some demo messages based on chat title
      if (chatTitle.contains("cat is not feeling well")) {
        _messages.addAll([
          ChatMessage(
            text: "I think my cat is not feeling well, he vomits three times already today, what should I do?",
            isUser: true,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          ChatMessage(
            text: "Oh no! I'm sorry to hear that your cat is unwell. Vomiting can be concerning. Let's help your cat feel better. Can you tell me more details about the symptoms?",
            isUser: false,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ]);
      } else if (chatTitle.contains("allergies")) {
        _messages.addAll([
          ChatMessage(
            text: "How can I handle my pet's allergies?",
            isUser: true,
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          ),
          ChatMessage(
            text: "Pet allergies can be managed in several ways. First, let's identify what type of allergies your pet has. Are they food allergies, environmental allergies, or skin allergies?",
            isUser: false,
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          ),
        ]);
      } else if (chatTitle.contains("dog")) {
        _messages.addAll([
          ChatMessage(
            text: "How to potty train a 5 month old dog?",
            isUser: true,
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
          ),
          ChatMessage(
            text: "Great question! At 5 months, your puppy is at a perfect age for potty training. Here are some effective strategies: 1) Establish a routine, 2) Use positive reinforcement, 3) Watch for signs, 4) Be consistent with commands.",
            isUser: false,
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ]);
      }
    });
    
    // Scroll to bottom after loading
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });
  }

  Widget _buildHistorySection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF999999),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  Widget _buildChatHistoryItem({
    required String title,
    required String time,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chat_bubble_outline,
                size: 16,
                color: Color(0xFF999999),
              ),
            ],
          ),
        ),
      ),    );
  }
  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final userMessage = _messageController.text.trim();
      _messageController.clear();
      
      setState(() {
        _messages.add(ChatMessage(
          text: userMessage,
          isUser: true,
          timestamp: DateTime.now(),
        ));
        _isTyping = true;
      });

      // Auto-scroll to bottom
      _scrollToBottom();

      // Simulate AI response delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isTyping = false;
            _messages.add(ChatMessage(
              text: _generateAIResponse(userMessage),
              isUser: false,
              timestamp: DateTime.now(),
            ));
          });
          _scrollToBottom();
        }
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  String _generateAIResponse(String userMessage) {
    // Simple AI response generator based on keywords
    final message = userMessage.toLowerCase();
    
    if (message.contains('sick') || message.contains('vomit') || message.contains('ill')) {
      return "I understand you're concerned about your pet's health. If your pet is vomiting frequently, it's important to monitor them closely. Please consider contacting a veterinarian if symptoms persist or worsen.";
    } else if (message.contains('food') || message.contains('eat') || message.contains('feed')) {
      return "Great question about pet nutrition! The best diet depends on your pet's age, size, and health condition. I recommend consulting with your vet for personalized dietary advice.";
    } else if (message.contains('train') || message.contains('behavior')) {
      return "Training and behavior are important aspects of pet care! Consistency and positive reinforcement work best. What specific behavior would you like to work on?";
    } else if (message.contains('hello') || message.contains('hi')) {
      return "Hello! I'm Mora, your AI pet care assistant. I'm here to help you with any questions about your beloved pets. What would you like to know?";
    } else {
      return "That's an interesting question about pet care! While I try my best to help, for specific medical concerns, I always recommend consulting with a qualified veterinarian who can examine your pet directly.";
    }
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.refresh, color: Color(0xFF666666)),
              title: const Text("Clear Chat"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _messages.clear();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: Color(0xFF666666)),
              title: const Text("Copy Conversation"),
              onTap: () {
                Navigator.pop(context);
                // Implement copy functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Conversation copied to clipboard")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Color(0xFF666666)),
              title: const Text("Share Chat"),
              onTap: () {
                Navigator.pop(context);
                // Implement share functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Share functionality not implemented yet")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFF666666)),
              title: const Text("About Mora"),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4FD),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/robot_mora.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text("About Mora"),
          ],
        ),
        content: const Text(
          "Mora is your intelligent pet care assistant, powered by AI to help you take the best care of your beloved pets. "
          "Ask me anything about pet health, behavior, nutrition, and more!",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,      appBar: AppBar(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Mora",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    _messages.isEmpty ? "Start a conversation" : "Online",
                    style: const TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Show more options
              _showMoreOptions(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Text(
              "Today",
              style: TextStyle(
                color: Color(0xFF999999),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          // Message Input
          Container(
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
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 0, 115, 255),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Align(
        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: message.isUser 
                ? const Color(0xFF2196F3)
                : const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              color: message.isUser ? Colors.white : const Color(0xFF333333),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FD),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/robot_mora.png',
                    width: 12,
                    height: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Mora is typing",
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 24,
                height: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDot(0),
                    _buildDot(1),
                    _buildDot(2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600 + (index * 200)),
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFF999999),
        shape: BoxShape.circle,
      ),
      child: AnimatedOpacity(
        opacity: _isTyping ? 1.0 : 0.3,
        duration: Duration(milliseconds: 600 + (index * 200)),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF999999),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

// Chat Message Model
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