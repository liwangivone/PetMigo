import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/chat/chat_bloc.dart';
import 'package:frontend/bloc/clinic/clinic_bloc.dart';
import 'package:frontend/bloc/petschedule/pet_schedule_bloc.dart';
import 'package:frontend/bloc/user/user_bloc.dart';
import 'package:frontend/bloc/vet/vet_bloc.dart';
import 'package:frontend/models/chat_model.dart';
import 'package:frontend/models/pet_model.dart';
import 'package:frontend/services/chat_service.dart';
import 'package:frontend/services/clinic_service.dart';
import 'package:frontend/services/pet_service.dart';
import 'package:frontend/services/petschedules_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/services/vet_service.dart';
import 'package:frontend/views/pages/vet_chat_page.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/bloc/pet/pet_bloc.dart';
import 'package:frontend/models/vet_model.dart';
import 'package:frontend/views/pages/pages.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _userBloc = UserBloc(userService: UserService());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _userBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // App is going to background or closed
      _userBloc.stopPingTimer();
    } else if (state == AppLifecycleState.resumed) {
      // App is coming back to foreground
      _checkAndRestartPing();
    }
  }

  Future<void> _checkAndRestartPing() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userid');
    if (userId != null && userId.isNotEmpty) {
      _userBloc.startPingTimer(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
        GoRoute(path: '/vet/home', builder: (_, __) => const VetHomePage()),
        GoRoute(path: '/onboarding', builder: (_, __) => OnboardingScreen()),
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
        GoRoute(path: '/vet/register', builder: (_, __) => const VetRegisterScreen()),
        GoRoute(path: '/choose-login', builder: (_, __) => const ChooseRolePage()),
        GoRoute(path: '/vet/login', builder: (_, __) => const VetLoginScreen()),
        GoRoute(path: '/choosepet', builder: (_, __) => const ChoosePetPage()),
        GoRoute(path: '/dashboard', builder: (_, __) => const HomePage()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
        GoRoute(path: '/edit-profile', builder: (_, __) => const EditProfilePage()),
        GoRoute(path: '/askai', builder: (_, __) => const AskAIWelcome()),
        GoRoute(path: '/myexpenses', builder: (_, __) => const MyExpensesPage()),
        GoRoute(path: '/add-petschedule', builder: (_, __) => const PetScheduleInputView()),
        GoRoute(path: '/need-vet', builder: (_, __) => VetListPage()),
        GoRoute(
          path: '/detail-vet',
          builder: (_, state) => VetDetailPage(vet: state.extra as VetModel),
        ),
        GoRoute(
          path: '/pet-detail',
          builder: (_, state) {
            final extra = state.extra;
            if (extra == null || extra is! Pet) {
              Future.microtask(() => _.go('/dashboard'));
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return PetDetailPage(pet: extra);
          },
        ),
        GoRoute(
          path: '/edit-pet',
          builder: (_, state) {
            final extra = state.extra;
            if (extra == null || extra is! Pet) {
              Future.microtask(() => _.go('/dashboard'));
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return PetEditPage(pet: extra);
          },
        ),
        GoRoute(
          path: '/chat',
          builder: (_, state) {
            final extra = state.extra;

            if (extra is Map<String, dynamic>) {
              final vet = extra['vet'] as VetModel?;
              final chat = extra['chat'] as ChatModel?;
              final isVet = extra['isVet'] as bool? ?? false;

              if (vet == null || chat == null) {
                Future.microtask(() => isVet ? _.go('/vet/home') : _.go('/need-vet'));
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              return VetChatPage(vet: vet, chat: chat, isVet: isVet);
            }

            if (extra is ChatModel) {
              final vet = extra.vet;

              if (vet == null) {
                Future.microtask(() => _.go('/vet/home'));
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              return VetChatPage(vet: vet, chat: extra, isVet: true);
            }

            Future.microtask(() => _.go('/need-vet'));
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          },
        ),
        GoRoute(path: '/vet-dashboard', builder: (_, __) => const VetDashboardPage()),
        GoRoute(path: '/vet-chats', builder: (_, __) => const VetChatListPage()),
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _userBloc),
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: const Center(child: Text('Login Page - Not implemented yet')),
      );
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
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

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Subscription'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: Text('Subscription Page - Not implemented yet')),
      );
}