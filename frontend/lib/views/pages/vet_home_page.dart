part of 'pages.dart';

class VetHomePage extends StatefulWidget {
  const VetHomePage({super.key});

  @override
  State<VetHomePage> createState() => _VetHomePageState();
}

class _VetHomePageState extends State<VetHomePage> {
  bool showAllChats = false;
  String vetId = '';

  @override
  void initState() {
    super.initState();
    _getVetId();
  }

  Future<void> _getVetId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString('vetid');
    if (storedId != null && storedId.isNotEmpty) {
      setState(() => vetId = storedId);
      context.read<ChatBloc>().add(FetchChatsByRole('VET', vetId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: vetId.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, chatState) {
                  return _buildVetContent(chatState);
                },
              ),
            ),
    );
  }

  Widget _buildVetContent(ChatState chatState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVetHeader(),
        const SizedBox(height: 20),
        _buildPremiumCard(),
        const SizedBox(height: 20),
        _buildChatHistorySection(chatState),
      ],
    );
  }

  Widget _buildVetHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, Doctor!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Your recent consultations with pet owners',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.go('/profile'),
          child: CircleAvatar(
            radius: 26,
            backgroundColor: Colors.pink[100],
            child: Icon(Icons.person, color: Colors.red[900]),
          ),
        ),
      ],
    );
  }

  Widget _buildChatHistorySection(ChatState chatState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Consultations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => showAllChats = !showAllChats),
              child: Text(
                showAllChats ? 'Show less' : 'View all',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (chatState is ChatListLoaded)
          _buildChatList(chatState.chats)
        else if (chatState is ChatError)
          Text(
            'Error loading chats: ${chatState.message}',
            style: const TextStyle(color: Colors.red),
          )
        else
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildChatList(List<ChatModel> chats) {
    final sortedChats = List<ChatModel>.from(chats)
      ..sort((a, b) {
        if (a.messages.isEmpty && b.messages.isEmpty) return 0;
        if (a.messages.isEmpty) return 1;
        if (b.messages.isEmpty) return -1;
        return b.messages.last.sentDate.compareTo(a.messages.last.sentDate);
      });

    if (sortedChats.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'No consultation history available.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final displayedChats = showAllChats ? sortedChats : sortedChats.take(2).toList();

    return Column(
      children: displayedChats.map((chat) => _buildConsultationCard(chat)).toList(),
    );
  }

  Widget _buildConsultationCard(ChatModel chat) {
    final lastMessage = chat.messages.isNotEmpty ? chat.messages.last : null;
    final lastMessageText = lastMessage?.text ?? 'No messages yet';
    final lastMessageTime = lastMessage?.sentDate ?? DateTime.now();
    final userName = chat.user?.name ?? 'Pet Owner';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => context.go('/chat', extra: chat),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: Colors.blue[100],
          child: const Icon(Icons.pets, color: Colors.blue),
        ),
        title: Text(
          userName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          lastMessageText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Text(
          _formatChatTime(lastMessageTime),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  String _formatChatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);
    final diffDays = today.difference(messageDate).inDays;

    if (diffDays == 0) {
      return DateFormat('h:mm a').format(time);
    } else if (diffDays == 1) {
      return 'Yesterday';
    } else if (diffDays < 7) {
      return DateFormat('EEEE').format(time);
    } else {
      return DateFormat('MMM d').format(time);
    }
  }

  Widget _buildPremiumCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[300],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Professional Tools\nEnhance your veterinary practice',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange,
              shape: const StadiumBorder(),
            ),
            child: const Text('Explore'),
          ),
        ],
      ),
    );
  }
}