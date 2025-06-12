part of 'pages.dart';

class VetDashboardPage extends StatelessWidget {
  const VetDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Welcome Back, Ivone!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/ivone.png'), // Ganti sesuai gambar Anda
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Latest Chat
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Latest Chat',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go('/vet-chats');
                    },
                    child: const Text(
                      'View all Chat',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const ChatTile(
                name: 'Aditya',
                message: 'Kucing Saya Sakit Dok',
                time: 'Today, 2:00 PM',
                avatar: 'assets/images/user1.png',
              ),
              const ChatTile(
                name: 'Mahmud',
                message: 'Selamat siang dok, maaf men...',
                time: 'Yesterday, 1:00 PM',
                avatar: 'assets/images/user2.png',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.2),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) => _onVetNavTap(context, index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
          ],
          selectedItemColor: const Color(0xFFFF7A3D),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  void _onVetNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/vet-dashboard');
        break;
      case 1:
        context.go('/vet-chats');
        break;
    }
  }
}