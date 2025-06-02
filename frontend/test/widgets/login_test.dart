import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/login_bloc.dart';
import 'package:frontend/views/pages/pages.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('LoginScreen widget test with navigation', (WidgetTester tester) async {
    // 1. Siapkan GoRouter dengan 3 route (login, register, dashboard)
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Register Page')),
          ),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Dashboard Page')),
          ),
        ),
      ],
    );

    // 2. Bungkus widget yang akan diuji
    Widget makeTestableWidget() {
      return BlocProvider<LoginBloc>(
        create: (_) => LoginBloc(),
        child: MaterialApp.router(
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
        ),
      );
    }

    // 3. Jalankan test
    await tester.pumpWidget(makeTestableWidget());

    // 4. Verifikasi elemen UI ada
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text("Don't have an account? "), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);

    // 5. Simulasikan klik "Sign Up" untuk navigasi ke Register Page
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    // 6. Pastikan sekarang berada di halaman register
    expect(find.text('Register Page'), findsOneWidget);
  });
}
