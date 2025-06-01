part of 'pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Ganti pushReplacementNamed dengan context.go()
    Future.delayed(const Duration(seconds: 4), () {
      try {
        context.go('/onboarding');
      } catch (e) {
        debugPrint('Error navigasi: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash.gif',
              width: 360,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Error memuat gambar: $error');

                return const Column(
                  children: [
                    Icon(Icons.pets, size: 100, color: Colors.blue),
                    SizedBox(height: 20),
                    Text('Pet Migo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}