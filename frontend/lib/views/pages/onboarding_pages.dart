part of 'pages.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboarding/onboarding1.png',
      'title': 'Welcome to PetMigo !',
      'description': 'Manage all your pets in one place',
    },
    {
      'image': 'assets/images/onboarding/onboarding2.png',
      'title': 'Ask Anything, Anytime',
      'description': 'Use our AI assistant to get instant advice, identify symptoms, or learn more about your pet care',
    },
    {
      'image': 'assets/images/onboarding/onboarding3.png',
      'title': 'Talk to Trusted Vets Anytime',
      'description': 'Chat or call directly with verified veterinarians, whenever your pet needs expert care',
    },
    {
      'image': 'assets/images/onboarding/onboarding4.png',
      'title': 'Stay on Top of Pet Expenses',
      'description': 'Monitor your pet care budget by category, with clear summaries to help you manage',
    },
  ];

  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RegisterPage()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tetap gunakan extendBodyBehindAppBar untuk status bar transparan
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                final data = onboardingData[index];
                return Column(
                  children: [
                    // Banner biru yang sekarang mentok ke atas
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.58,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCF0FF),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(160),
                          bottomRight: Radius.circular(160),
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          data['image']!,
                          height: 260,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          // Title
                          Text(
                            data['title']!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          // Description
                          Text(
                            data['description']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Indicator dots
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index 
                        ? const Color(0xFFFF9052) 
                        : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          // Button area
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9052),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                minimumSize: const Size(double.infinity, 50),
                elevation: 0,
              ),
              onPressed: _nextPage,
              child: const Text(
                "Next",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}