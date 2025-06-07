import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/my_expenses_bloc/expenses_bloc.dart';
import 'views/pages/pages.dart';
import 'package:frontend/models/vet_models.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/choosepet',
          builder: (context, state) => const ChoosePetPage(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: '/edit-profile',
          builder: (context, state) => const EditProfilePage(),
        ),
          GoRoute(
          path: '/askai',
          builder: (context, state) => const AskAIWelcome(),
        ),
        GoRoute(
          path: '/myexpenses', 
          builder: (context, state) => const MyExpensesPage(),
        ),
        GoRoute(
            path: '/need-vet',
            builder: (context, state) => VetListPage(),
          ),
        GoRoute(
          path: '/detail-vet',
          builder: (context, state) {
            final vet = state.extra as VetModel;
            return VetDetailPage(vet: vet);
          },
        ),
        GoRoute(
          path: '/chat-vet',
          builder: (context, state) {
            final vet = state.extra as VetModel;
            return ChatPage(vet: vet);
          },
        ),
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ExpensesBloc()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(
        child: Text('Login Page - Not implemented yet'),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Dashboard Page - Not implemented yet'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/profile'),
              child: const Text('Go to Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: Text('Subscription Page - Not implemented yet'),
      ),
    );
  }
}