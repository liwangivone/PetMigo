part of 'pages.dart';

class ChooseRolePage extends StatefulWidget {
  const ChooseRolePage({Key? key}) : super(key: key);

  @override
  State<ChooseRolePage> createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends State<ChooseRolePage> {
  String? _selectedRole; // 'vet' atau 'user'

  void _goToLogin() {
    if (_selectedRole == 'vet') {
      context.go('/vet/login');
    } else if (_selectedRole == 'user') {
      context.go('/login');
    }
  }

  Widget _buildRoleOption(String role, String assetPath) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Column(
        children: [
          Container(
            height: 110,
            width: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.orange : Colors.grey.shade300,
                width: 3,
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(assetPath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(role.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.orange : Colors.grey.shade800,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          AppBar(toolbarHeight: 0, backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            const Text(
              'Select your role',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // opsi VET & USER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRoleOption('vet', 'assets/images/vet.png'),
                _buildRoleOption('user', 'assets/images/user.png'),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedRole == null ? null : _goToLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  disabledBackgroundColor: Colors.orange.withOpacity(0.4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Confirm'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
