part of 'pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Gunakan Future.delayed sebagai alternatif Timer untuk transisi
    Future.delayed(const Duration(seconds: 3), () {
      // Gunakan try-catch untuk menangani error navigasi
      try {
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        debugPrint('Error navigasi: $e');
        // Fallback navigation jika route '/home' bermasalah
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const OnboardingScreen())
        );
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
            // Gunakan Image.asset dengan error handler
            Image.asset(
              'assets/images/petmigo_logo.png',
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


