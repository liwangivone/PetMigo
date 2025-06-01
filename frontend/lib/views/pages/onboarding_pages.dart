part of 'pages.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final PageController _pageController = PageController();

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

  void _nextPage(BuildContext context, int currentPage) {
    if (currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      context.read<OnboardingBloc>().add(OnboardingNextPressed());
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(totalPages: onboardingData.length),
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
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
            body: SafeArea(
              child: Column(
                children: [
                  // Page content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        context.read<OnboardingBloc>().add(OnboardingPageChanged(index));
                      },
                      itemCount: onboardingData.length,
                      itemBuilder: (context, index) {
                        final data = onboardingData[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 50,
                                child: Center(
                                  child: Image.asset(
                                    data['image']!,
                                    fit: BoxFit.contain,
                                    height: MediaQuery.of(context).size.height * 0.37,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Flexible(
                                flex: 15,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['title']!,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,                          
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      data['description']!,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 15,
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Dot indicator
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color: state.currentPage == index
                                ? const Color(0xFFFF9052)
                                : Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Next button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(60, 0, 60, 120),
                    child: SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9052),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => _nextPage(context, state.currentPage),
                        child: Text(
                          "Next",
                          style: GoogleFonts.poppins(
                            color: Colors.white, 
                            fontWeight: FontWeight.w500, 
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}