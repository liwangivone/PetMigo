part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedType = 'All';
  bool showAllSchedules = false;
  bool showAllChats = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadData();
    _getUserId();
  }

  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userid');
    });
    if (userId != null) {
      context.read<ChatBloc>().add(FetchChatsByRole('USER', userId!));
    }
  }

  void _loadData() {
    context.read<UserBloc>().add(GetUserData());
    context.read<PetBloc>().add(GetPetData());
    context.read<PetScheduleBloc>().add(LoadPetSchedules());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            if (userState is! UserLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            return BlocBuilder<PetBloc, PetState>(
              builder: (context, petState) {
                if (petState is! PetLoaded) {
                  return const Center(child: CircularProgressIndicator());
                }
                return BlocBuilder<PetScheduleBloc, PetScheduleState>(
                  builder: (context, schedState) {
                    if (schedState is! PetScheduleLoaded) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, chatState) {
                        return _buildContent(
                          userState.user,
                          petState.pets,
                          schedState.schedules,
                          chatState,
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavbar(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/choosepet'),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent(User user, List<Pet> pets, List<PetSchedule> schedules, ChatState chatState) {
    final filteredPets = selectedType.toLowerCase() == 'all'
        ? pets
        : pets.where((p) => p.type.toLowerCase() == selectedType.toLowerCase()).toList();

    final now = DateTime.now();
    final upcoming = schedules.where((s) => s.date.isAfter(now)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final past = schedules.where((s) => s.date.isBefore(now)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final approaching = upcoming
        .where((s) => s.date.difference(now).inDays <= 3)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final limitedApproaching = approaching.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(user),
        const SizedBox(height: 20),
        _buildPremiumCard(),
        const SizedBox(height: 20),
        _buildScheduleSection(
          upcoming: upcoming,
          limitedApproaching: limitedApproaching,
          past: past,
          showAll: showAllSchedules,
          toggleShowAll: () => setState(() => showAllSchedules = !showAllSchedules),
        ),
        const SizedBox(height: 20),
        _buildChatHistorySection(chatState),
        const SizedBox(height: 20),
        const Text('My pets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          children: ['All', 'Cat', 'Dog'].map((label) => _buildChip(label)).toList(),
        ),
        const SizedBox(height: 10),
        filteredPets.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: Text('Kamu belum punya hewan peliharaan.', style: TextStyle(color: Colors.grey)),
              )
            : Column(
                children: filteredPets.map((pet) => _buildPetCard(pet)).toList(),
              ),
      ],
    );
  }

  Widget _buildHeader(User user) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello, ${user.name}!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text('Your pets miss you, check it now', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.go('/profile'),
          child: CircleAvatar(
            radius: 26,
            backgroundColor: Colors.pink[100],
            backgroundImage: user.profileImageUrl != null ? NetworkImage(user.profileImageUrl!) : null,
            child: user.profileImageUrl == null ? Icon(Icons.person, color: Colors.red[900]) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label) {
    final isSelected = selectedType.toLowerCase() == label.toLowerCase();
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: Colors.blue[100],
        onSelected: (_) => setState(() => selectedType = label),
      ),
    );
  }

  Widget _buildScheduleSection({
    required List<PetSchedule> upcoming,
    required List<PetSchedule> limitedApproaching,
    required List<PetSchedule> past,
    required bool showAll,
    required VoidCallback toggleShowAll,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Upcoming Schedules', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: toggleShowAll,
              child: Text(
                showAll ? 'Show limited' : 'View all',
                style: const TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (showAll) ...[
          const Text('Upcoming schedules', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 6),
          upcoming.isEmpty
              ? const Text('No upcoming schedules.')
              : Column(children: upcoming.map(_buildScheduleCard).toList()),
          const SizedBox(height: 16),
          const Text('Past schedules', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 6),
          past.isEmpty ? const Text('No past schedules.') : Column(children: past.map(_buildScheduleCard).toList()),
        ] else ...[
          if (upcoming.isEmpty)
            const Text('No upcoming schedules.')
          else if (limitedApproaching.isEmpty)
            const Text('No upcoming schedules in 3 days.')
          else
            Column(children: limitedApproaching.map(_buildScheduleCard).toList()),
        ],
      ],
    );
  }

  Widget _buildScheduleCard(PetSchedule schedule) {
    IconData icon;
    Color color;
    final label = _capitalize(schedule.category.name);

    switch (label) {
      case 'Vaccination':
        icon = Icons.medical_services;
        color = Colors.red;
        break;
      case 'Grooming':
        icon = Icons.cut;
        color = Colors.blue;
        break;
      case 'Food':
        icon = Icons.restaurant;
        color = Colors.green;
        break;
      case 'Toys':
        icon = Icons.toys;
        color = Colors.orange;
        break;
      case 'Snack':
        icon = Icons.fastfood;
        color = Colors.purple;
        break;
      default:
        icon = Icons.event_note;
        color = Colors.grey;
        break;
    }

    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color)),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(_formatScheduleDate(schedule)),
      ),
    );
  }

  Widget _buildPetCard(Pet pet) {
    final isFemale = pet.gender.toLowerCase() == 'female';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => context.go('/pet-detail', extra: pet),
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: AssetImage(pet.type.toLowerCase() == 'cat'
              ? 'assets/images/cat.png'
              : 'assets/images/dog.png'),
        ),
        title: Text(pet.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pet.breed ?? '-'),
            Row(
              children: [
                Icon(isFemale ? Icons.female : Icons.male, size: 14, color: isFemale ? Colors.pink : Colors.blue),
                const SizedBox(width: 4),
                Text(pet.gender),
                const SizedBox(width: 10),
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(_calculateAge(pet.birthdate)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatHistorySection(ChatState chatState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Chat History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () => setState(() => showAllChats = !showAllChats),
              child: Text(
                showAllChats ? 'Show less' : 'View all',
                style: const TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (chatState is ChatListLoaded) 
          _buildChatList(chatState.chats)
        else if (chatState is ChatError)
          Text('Error loading chats: ${chatState.message}', style: TextStyle(color: Colors.red))
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
        child: Text('No chat history available.', style: TextStyle(color: Colors.grey)),
      );
    }

    final displayedChats = showAllChats ? sortedChats : sortedChats.take(2).toList();

    return Column(
      children: displayedChats.map((chat) => _buildChatCard(chat)).toList(),
    );
  }

  Widget _buildChatCard(ChatModel chat) {
    final lastMessage = chat.messages.isNotEmpty 
        ? chat.messages.last 
        : null;
    final lastMessageText = lastMessage?.messagetext ?? 'No messages yet';
    final lastMessageTime = lastMessage?.sentDate ?? DateTime.now();
    final vetName = chat.vet?.name ?? 'Vet';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => context.go('/chat', extra: {
          'chat': chat,
          'vet': chat.vet,
        }),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: Colors.grey[200],
          child: Icon(
            Icons.medical_services,
            color: Colors.grey[600],
          ),
        ),
        title: Text(vetName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(lastMessageText, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Text(
          _formatChatTime(lastMessageTime),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

  String _formatScheduleDate(PetSchedule s) {
    final now = DateTime.now();
    final localDate = s.date.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(localDate.year, localDate.month, localDate.day);
    final diffDays = target.difference(today).inDays;

    if (localDate.isAfter(now)) {
      String label;
      if (diffDays == 0) {
        label = 'Today';
      } else if (diffDays == 1) {
        label = 'Tomorrow';
      } else if (diffDays < 7) {
        label = DateFormat('EEEE').format(localDate);
      } else {
        label = DateFormat('dd MMM yyyy').format(localDate);
      }
      return '$label, ${DateFormat('h:mm a').format(localDate)} - ${s.petName}';
    }

    final diff = now.difference(localDate);
    if (diff.inDays >= 365) {
      final years = (diff.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago - ${s.petName}';
    } else if (diff.inDays >= 30) {
      final months = (diff.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago - ${s.petName}';
    } else if (diff.inDays >= 1) {
      return '${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'} ago - ${s.petName}';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} ${diff.inHours == 1 ? 'hour' : 'hours'} ago - ${s.petName}';
    }
    return '${diff.inMinutes} ${diff.inMinutes == 1 ? 'minute' : 'minutes'} ago - ${s.petName}';
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

  String _calculateAge(DateTime birthdate) {
    final now = DateTime.now();
    int age = now.year - birthdate.year;
    if (now.month < birthdate.month || (now.month == birthdate.month && now.day < birthdate.day)) {
      age--;
    }
    return '$age years';
  }

  Widget _buildPremiumCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[300],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text('Go premium!\nGet unlimited access to all features', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange,
              shape: const StadiumBorder(),
            ),
            child: const Text('Subscribe'),
          ),
        ],
      ),
    );
  }
}