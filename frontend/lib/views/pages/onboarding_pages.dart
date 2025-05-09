part of 'pages.dart';

class OnboardingData {
  final String image;
  final String title;
  final String description;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onDone;
  
  const OnboardingScreen({
    super.key,
    required this.onDone,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      image: 'assets/images/onboarding1.png',
      title: 'Welcome to PetMigo !',
      description: 'Manage all your pets in one place',
    ),
    OnboardingData(
      image: 'assets/images/onboarding2.png',
      title: 'Ask Anything, Anytime',
      description: 'Use our AI assistant to get instant advice, identify symptoms, or learn more about your pet care',
    ),
    OnboardingData(
      image: 'assets/images/onboarding3.png',
      title: 'Talk to Trusted Vets Anytime',
      description: 'Chat or call directly with verified veterinarians, whenever your pet needs expert care',
    ),
    OnboardingData(
      image: 'assets/images/onboarding4.png',
      title: 'Stay on Top of Pet Expenses',
      description: 'Monitor your pet care budget by category, with clear summary to help you manage better',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Status bar with time and icons
            _buildStatusBar(),
            
            // Page view for onboarding content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_pages[index]);
                },
              ),
            ),
            
            // Page indicator dots
            _buildPageIndicator(),
            
            const SizedBox(height: 20),
            
            // Next button
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '18:10',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              const Icon(Icons.signal_cellular_4_bar, size: 16),
              const SizedBox(width: 4),
              const Icon(Icons.wifi, size: 16),
              const SizedBox(width: 4),
              Icon(Icons.battery_full, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration in blue circle background
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F4FF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                data.image,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Title
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            data.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 8,
            width: _currentPage == index ? 20 : 8,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? const Color(0xFFFE8B4A)
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            if (_currentPage < _pages.length - 1) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            } else {
              widget.onDone(); // Call the callback when done with onboarding
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFE8B4A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Next',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}