import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/chat/chat_bloc.dart';
import 'package:frontend/bloc/clinic/clinic_bloc.dart';
import 'package:frontend/bloc/petschedule/pet_schedule_bloc.dart';
import 'package:frontend/bloc/vet/vet_bloc.dart';
import 'package:frontend/services/chat_service.dart';
import 'package:frontend/services/clinic_service.dart';
import 'package:frontend/services/pet_service.dart';
import 'package:frontend/services/petschedules_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/services/vet_service.dart';
import 'package:frontend/views/pages/vet_chat_page.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/bloc/user/user_bloc.dart';
import 'package:frontend/bloc/pet/pet_bloc.dart';
import 'package:frontend/models/vet_model.dart';
import 'package:frontend/views/pages/pages.dart'; // pastikan ini mengimpor semua page

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
            final extra = state.extra;

            if (extra == null || extra is! Map<String, dynamic> || 
                extra['vet'] == null || extra['chat'] == null) {
              // redirect ke /need-vet jika data tidak lengkap
              Future.microtask(() => context.go('/need-vet'));
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final vet = extra['vet'] as VetModel;
            final chat = extra['chat']; // sesuaikan dengan tipe ChatModel Anda
            return ChatPage(vet: vet, chat: chat);
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
        BlocProvider(create: (_) => UserBloc(userService: UserService())),
        BlocProvider(create: (_) => PetBloc(PetService())),
        BlocProvider(create: (_) => PetScheduleBloc(PetScheduleService())),
        BlocProvider(create: (_) => VetBloc(VetService())),
        BlocProvider(create: (_) => ClinicBloc(ClinicsService())),
        BlocProvider(create: (_) => ChatBloc(ChatService())),
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