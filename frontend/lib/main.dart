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
        GoRoute(
          path: '/vet-dashboard',
          builder: (context, state) => const VetDashboardPage(),
        ),
        GoRoute(
          path: '/vet-chats',
          builder: (context, state) => const VetChatListPage(),
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

