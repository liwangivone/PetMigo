part of 'pages.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;

  const BottomNavbar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/askai');
        break;
      case 2:
        context.go('/needvet');
        break;
      case 3:
        context.go('/myexpenses');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 2, color: Colors.black12),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedItemColor: Color(0xFFFF7A00), // Orange highlight
        unselectedItemColor: Colors.grey.shade500,
        currentIndex: currentIndex,
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'My Pet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy), // robot face
            label: 'Ask AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Need Vet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'My Expenses',
          ),
        ],
      ),
    );
  }
}
