part of 'pages.dart';

class VetDetailPage extends StatelessWidget {
  final VetModel vet;
  const VetDetailPage({super.key, required this.vet});

  String _clean(String raw) {
    final s = raw.trim();
    return (s.isEmpty || s.toLowerCase() == 'string' || s.toLowerCase() == 'null')
        ? '-'
        : raw;
  }

  Future<void> _startChat(BuildContext ctx) async {
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString('userid');
    if (userid == null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('User belum login')),
      );
      return;
    }

    final vetid = vet.id;
    ctx.read<ChatBloc>().add(CreateChatWithIds(userId: userid, vetId: vetid));
  }

  @override
  Widget build(BuildContext context) {
    final specialization =
        _clean(vet.specialization) == '-' ? 'Dokter Hewan' : vet.specialization;

    return BlocListener<ChatBloc, ChatState>(
      listener: (ctx, state) {
        if (state is ChatLoaded) {
          ctx.go('/chat', extra: {
            'vet': vet,
            'chat': state.chat,
          });
        } else if (state is ChatError) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text('Vets Detail',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(vet.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vet.name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Text(specialization,
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFF6B7280))),
                          const SizedBox(height: 8),
                          const Text('Pengalaman',
                              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                          Text('${vet.experienceYears} Tahun',
                              style:
                                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Overview
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Overview',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Text(_clean(vet.overview),
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF6B7280), height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Schedule
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Schedule',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Text(_clean(vet.schedule),
                        style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
        // Bottom Chat Button
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, -2))],
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _startChat(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A3D),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text('Start chat',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}