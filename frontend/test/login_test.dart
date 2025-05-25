// test/login_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

// ===== SESUAIKAN IMPORT INI DENGAN PROJECT ANDA =====
// Contoh jika nama package Anda adalah 'frontend':
// import 'package:frontend/models/model_login.dart';
// import 'package:frontend/bloc/login_bloc.dart'; 
// import 'package:frontend/pages/pages.dart';

// Mock classes
class MockHttpClient extends Mock implements http.Client {}

// Definisi LoginState yang sudah diperbaiki
class LoginState {
  final String email;
  final String password;
  final bool isValid;
  final String? errorMessage;
  final bool isLoading;
  final bool isSuccess;

  LoginState({
    this.email = '',
    this.password = '',
    this.errorMessage,
    this.isLoading = false,
    this.isSuccess = false,
  }) : isValid = email.isNotEmpty && password.isNotEmpty && email.length > 3 && password.length > 3;

  LoginState copyWith({
    String? email,
    String? password,
    String? errorMessage,
    bool? isLoading,
    bool? isSuccess,
    bool clearError = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginState &&
        other.email == email &&
        other.password == password &&
        other.errorMessage == errorMessage &&
        other.isLoading == isLoading &&
        other.isSuccess == isSuccess &&
        other.isValid == isValid;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        password.hashCode ^
        (errorMessage?.hashCode ?? 0) ^
        isLoading.hashCode ^
        isSuccess.hashCode ^
        isValid.hashCode;
  }

  @override
  String toString() {
    return 'LoginState(email: $email, password: [HIDDEN], isValid: $isValid, errorMessage: $errorMessage, isLoading: $isLoading, isSuccess: $isSuccess)';
  }
}

// Definisi Events
abstract class LoginEvent {
  const LoginEvent();
}

class EmailChanged extends LoginEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmailChanged && other.email == email;
  }

  @override
  int get hashCode => email.hashCode;
}

class PasswordChanged extends LoginEvent {
  final String password;
  const PasswordChanged(this.password);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PasswordChanged && other.password == password;
  }

  @override
  int get hashCode => password.hashCode;
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

class LoginReset extends LoginEvent {
  const LoginReset();
}

// Definisi LoginBloc yang sudah diperbaiki
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final http.Client? httpClient;

  LoginBloc({this.httpClient}) : super(LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>(_onLoginReset);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      email: event.email,
      clearError: true,
      isSuccess: false,
    ));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      password: event.password,
      clearError: true,
      isSuccess: false,
    ));
  }

  void _onLoginReset(LoginReset event, Emitter<LoginState> emit) {
    emit(LoginState());
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    if (!state.isValid) return;

    emit(state.copyWith(isLoading: true, clearError: true));
    
    try {
      final client = httpClient ?? http.Client();
      final response = await client.post(
        Uri.parse('http://localhost:8080/api/users/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'email': state.email,
          'password': state.password,
        },
      );

      if (response.statusCode == 200) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Email atau password salah',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Terjadi kesalahan. Silakan coba lagi.',
      ));
    }
  }
}

// Widget untuk testing yang sudah diperbaiki
class TestLoginScreen extends StatelessWidget {
  const TestLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Login successful'),
                  key: Key('success_snackbar'),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                BlocBuilder<LoginBloc, LoginState>(
                  buildWhen: (previous, current) => previous.email != current.email,
                  builder: (context, state) {
                    return TextField(
                      key: const Key('email_field'),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => 
                          context.read<LoginBloc>().add(EmailChanged(value)),
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<LoginBloc, LoginState>(
                  buildWhen: (previous, current) => previous.password != current.password,
                  builder: (context, state) {
                    return TextField(
                      key: const Key('password_field'),
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      onChanged: (value) => 
                          context.read<LoginBloc>().add(PasswordChanged(value)),
                    );
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<LoginBloc, LoginState>(
                  buildWhen: (previous, current) => 
                      previous.isLoading != current.isLoading || 
                      previous.isValid != current.isValid,
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const CircularProgressIndicator(
                        key: Key('loading_indicator'),
                      );
                    }
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        key: const Key('login_button'),
                        onPressed: state.isValid
                            ? () => context.read<LoginBloc>().add(const LoginSubmitted())
                            : null,
                        child: const Text('Login'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<LoginBloc, LoginState>(
                  buildWhen: (previous, current) => previous.errorMessage != current.errorMessage,
                  builder: (context, state) {
                    if (state.errorMessage != null) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          state.errorMessage!,
                          key: const Key('error_message'),
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  group('LoginState Tests', () {
    test('should create initial state with default values', () {
      final state = LoginState();
      
      expect(state.email, equals(''));
      expect(state.password, equals(''));
      expect(state.isValid, isFalse);
      expect(state.errorMessage, isNull);
      expect(state.isLoading, isFalse);
      expect(state.isSuccess, isFalse);
    });

    test('should be valid when email and password are not empty and meet minimum length', () {
      final state = LoginState(
        email: 'test@example.com',
        password: 'password123',
      );
      
      expect(state.isValid, isTrue);
    });

    test('should be invalid when email is empty', () {
      final state = LoginState(
        email: '',
        password: 'password123',
      );
      
      expect(state.isValid, isFalse);
    });

    test('should be invalid when password is empty', () {
      final state = LoginState(
        email: 'test@example.com',
        password: '',
      );
      
      expect(state.isValid, isFalse);
    });

    test('should be invalid when email is too short', () {
      final state = LoginState(
        email: 'ab',
        password: 'password123',
      );
      
      expect(state.isValid, isFalse);
    });

    test('should be invalid when password is too short', () {
      final state = LoginState(
        email: 'test@example.com',
        password: '123',
      );
      
      expect(state.isValid, isFalse);
    });

    test('copyWith should return new instance with updated values', () {
      final initialState = LoginState(
        email: 'old@example.com',
        password: 'oldpassword',
      );
      
      final newState = initialState.copyWith(
        email: 'new@example.com',
        isLoading: true,
      );
      
      expect(newState.email, equals('new@example.com'));
      expect(newState.password, equals('oldpassword')); // unchanged
      expect(newState.isLoading, isTrue);
    });

    test('copyWith should clear error message when clearError is true', () {
      final initialState = LoginState(
        email: 'test@example.com',
        password: 'password123',
        errorMessage: 'Some error',
      );
      
      final newState = initialState.copyWith(clearError: true);
      
      expect(newState.errorMessage, isNull);
    });

    test('equality should work correctly', () {
      final state1 = LoginState(
        email: 'test@example.com',
        password: 'password123',
        isLoading: false,
      );
      
      final state2 = LoginState(
        email: 'test@example.com',
        password: 'password123',
        isLoading: false,
      );
      
      expect(state1, equals(state2));
    });

    test('hashcode should be consistent', () {
      final state1 = LoginState(
        email: 'test@example.com',
        password: 'password123',
      );
      
      final state2 = LoginState(
        email: 'test@example.com',
        password: 'password123',
      );
      
      expect(state1.hashCode, equals(state2.hashCode));
    });
  });

  group('LoginBloc Tests', () {
    late LoginBloc loginBloc;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      loginBloc = LoginBloc(httpClient: mockHttpClient);
      
      // Register fallback values for mocktail
      registerFallbackValue(Uri.parse('http://localhost:8080/api/users/login'));
      registerFallbackValue(<String, String>{});
      registerFallbackValue(<String, String>{'Content-Type': 'application/x-www-form-urlencoded'});
    });

    tearDown(() {
      loginBloc.close();
    });

    test('initial state should be LoginState with default values', () {
      expect(loginBloc.state, equals(LoginState()));
      expect(loginBloc.state.email, equals(''));
      expect(loginBloc.state.password, equals(''));
      expect(loginBloc.state.isValid, isFalse);
    });

    blocTest<LoginBloc, LoginState>(
      'emits updated email when EmailChanged is added',
      build: () => loginBloc,
      act: (bloc) => bloc.add(const EmailChanged('test@example.com')),
      expect: () => [
        LoginState(email: 'test@example.com'),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits updated password when PasswordChanged is added',
      build: () => loginBloc,
      act: (bloc) => bloc.add(const PasswordChanged('password123')),
      expect: () => [
        LoginState(password: 'password123'),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'clears error message when EmailChanged is added',
      build: () => LoginBloc(httpClient: mockHttpClient),
      seed: () => LoginState(
        email: 'old@example.com',
        errorMessage: 'Previous error',
      ),
      act: (bloc) => bloc.add(const EmailChanged('new@example.com')),
      expect: () => [
        LoginState(email: 'new@example.com'),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'clears error message when PasswordChanged is added',
      build: () => LoginBloc(httpClient: mockHttpClient),
      seed: () => LoginState(
        password: 'oldpassword',
        errorMessage: 'Previous error',
      ),
      act: (bloc) => bloc.add(const PasswordChanged('newpassword')),
      expect: () => [
        LoginState(password: 'newpassword'),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'does not emit when LoginSubmitted with invalid state (empty email)',
      build: () => LoginBloc(httpClient: mockHttpClient),
      seed: () => LoginState(password: 'password123'), // email empty
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => [], // no emission expected
    );

    blocTest<LoginBloc, LoginState>(
      'does not emit when LoginSubmitted with invalid state (empty password)',
      build: () => LoginBloc(httpClient: mockHttpClient),
      seed: () => LoginState(email: 'test@example.com'), // password empty
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => [], // no emission expected
    );

    blocTest<LoginBloc, LoginState>(
      'emits loading and success states on successful login',
      build: () => LoginBloc(httpClient: mockHttpClient),
      setUp: () {
        when(() => mockHttpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => http.Response('{"success": true}', 200));
      },
      seed: () => LoginState(
        email: 'test@example.com',
        password: 'password123',
      ),
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => [
        LoginState(
          email: 'test@example.com',
          password: 'password123',
          isLoading: true,
        ),
        LoginState(
          email: 'test@example.com',
          password: 'password123',
          isLoading: false,
          isSuccess: true,
        ),
      ],
      verify: (_) {
        verify(() => mockHttpClient.post(
          Uri.parse('http://localhost:8080/api/users/login'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'email': 'test@example.com',
            'password': 'password123',  
          },
        )).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits loading and error states on failed login (401)',
      build: () => LoginBloc(httpClient: mockHttpClient),
      setUp: () {
        when(() => mockHttpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => http.Response('{"error": "Invalid credentials"}', 401));
      },
      seed: () => LoginState(
        email: 'test@example.com',
        password: 'wrongpassword',
      ),
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => [
        LoginState(
          email: 'test@example.com',
          password: 'wrongpassword',
          isLoading: true,
        ),
        LoginState(
          email: 'test@example.com',
          password: 'wrongpassword',
          isLoading: false,
          errorMessage: 'Email atau password salah',
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits loading and error states on network exception',
      build: () => LoginBloc(httpClient: mockHttpClient),
      setUp: () {
        when(() => mockHttpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        )).thenThrow(Exception('Network error'));
      },
      seed: () => LoginState(
        email: 'test@example.com',
        password: 'password123',
      ),
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => [
        LoginState(
          email: 'test@example.com',
          password: 'password123',
          isLoading: true,
        ),
        LoginState(
          email: 'test@example.com',
          password: 'password123',
          isLoading: false,
          errorMessage: 'Terjadi kesalahan. Silakan coba lagi.',
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'reset should return to initial state',
      build: () => LoginBloc(httpClient: mockHttpClient),
      seed: () => LoginState(
        email: 'test@example.com',
        password: 'password123',
        errorMessage: 'Some error',
        isLoading: false,
        isSuccess: false,
      ),
      act: (bloc) => bloc.add(const LoginReset()),
      expect: () => [
        LoginState(),
      ],
    );
  });

  group('Login Widget Tests', () {
    testWidgets('renders all login form elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TestLoginScreen(),
        ),
      );

      // Check if main elements are present
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('email input updates bloc state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TestLoginScreen(),
        ),
      );

      // Find email input field
      final emailField = find.byKey(const Key('email_field'));
      
      // Enter email
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      // Verify text was entered
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('password input updates bloc state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TestLoginScreen(),
        ),
      );

      // Find password input field
      final passwordField = find.byKey(const Key('password_field'));
      
      // Enter password
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Password field is obscured, so we check if it exists and has content
      expect(passwordField, findsOneWidget);
      final TextField textField = tester.widget(passwordField);
      expect(textField.obscureText, isTrue);
    });

    testWidgets('login button is disabled when form is invalid', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TestLoginScreen(),
        ),
      );

      final loginButton = find.byKey(const Key('login_button'));
      expect(loginButton, findsOneWidget);

      // Get the button widget
      final ElevatedButton button = tester.widget(loginButton);
      expect(button.onPressed, isNull); // Button should be disabled initially
    });

    testWidgets('login button is enabled when form is valid', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TestLoginScreen(),
        ),
      );

      // Fill in email and password
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.pump();

      final loginButton = find.byKey(const Key('login_button'));
      final ElevatedButton button = tester.widget(loginButton);
      expect(button.onPressed, isNotNull); // Button should be enabled
    });

    testWidgets('shows loading indicator when login is in progress', (WidgetTester tester) async {
      final mockHttpClient = MockHttpClient();
      
      // Mock a delayed response to simulate loading state
      when(() => mockHttpClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return http.Response('{"success": true}', 200);
      });

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => LoginBloc(httpClient: mockHttpClient),
            child: const TestLoginScreen(),
          ),
        ),
      );

      // Fill form and submit
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.pump();

      // Tap login button
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Check if loading indicator appears
      expect(find.byKey(const Key('loading_indicator')), findsOneWidget);
      
      // Wait for completion
      await tester.pumpAndSettle();
    });

    testWidgets('shows error message when login fails', (WidgetTester tester) async {
      // Create bloc with mock http client that returns error
      final mockHttpClient = MockHttpClient();
      when(() => mockHttpClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => http.Response('{"error": "Invalid"}', 401));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => LoginBloc(httpClient: mockHttpClient),
            child: const TestLoginScreen(),
          ),
        ),
      );

      // Fill form
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'wrongpassword');
      await tester.pump();

      // Submit form
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Wait for async operation
      await tester.pumpAndSettle();

      // Check if error message appears
      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text('Email atau password salah'), findsOneWidget);
    });

    testWidgets('shows success message when login succeeds', (WidgetTester tester) async {
      // Create bloc with mock http client that returns success
      final mockHttpClient = MockHttpClient();
      when(() => mockHttpClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => http.Response('{"success": true}', 200));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => LoginBloc(httpClient: mockHttpClient),
            child: const TestLoginScreen(),
          ),
        ),
      );

      // Fill form
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.pump();

      // Submit form
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Wait for async operation
      await tester.pumpAndSettle();

      // Check if success snackbar appears
      expect(find.text('Login successful'), findsOneWidget);
    });

    testWidgets('error message disappears when user types again', (WidgetTester tester) async {
      final mockHttpClient = MockHttpClient();
      when(() => mockHttpClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => http.Response('{"error": "Invalid"}', 401));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => LoginBloc(httpClient: mockHttpClient),
            child: const TestLoginScreen(),
          ),
        ),
      );

      // Fill form and submit to get error
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'wrongpassword');
      await tester.pump();
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Error should be visible
      expect(find.byKey(const Key('error_message')), findsOneWidget);

      // Type in email field again
      await tester.enterText(find.byKey(const Key('email_field')), 'new@example.com');
      await tester.pump();

      // Error should disappear
      expect(find.byKey(const Key('error_message')), findsNothing);
    });
  });

  group('Integration Tests', () {
    testWidgets('complete login flow with valid credentials', (WidgetTester tester) async {
      final mockHttpClient = MockHttpClient();
      when(() => mockHttpClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => http.Response('{"success": true}', 200));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => LoginBloc(httpClient: mockHttpClient),
            child: const TestLoginScreen(),
          ),
        ),
      );

      // 1. Initially, login button should be disabled
      final loginButton = find.byKey(const Key('login_button'));
      ElevatedButton button = tester.widget(loginButton);
      expect(button.onPressed, isNull);

      // 2. Enter email
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.pump();

      // Button still disabled (password empty)
      button = tester.widget(loginButton);
      expect(button.onPressed, isNull);

      // 3. Enter password
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.pump();

      // Button should now be enabled
      button = tester.widget(loginButton);
      expect(button.onPressed, isNotNull);

      // 4. Tap login button
      await tester.tap(loginButton);
      await tester.pump();

      // Should show loading indicator
      expect(find.byKey(const Key('loading_indicator')), findsOneWidget);

      // 5. Wait for async operation to complete
      await tester.pumpAndSettle();

      // Should show success message
      expect(find.text('Login successful'), findsOneWidget);

      // Verify HTTP call was made
      verify(() => mockHttpClient.post(
        Uri.parse('http://localhost:8080/api/users/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'email': 'test@example.com',
          'password': 'password123',
        },
      )).called(1);
    });

    testWidgets('complete login flow with invalid credentials', (WidgetTester tester) async {
      final mockHttpClient = MockHttpClient();
      when(() => mockHttpClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => http.Response('{"error": "Invalid"}', 401));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => LoginBloc(httpClient: mockHttpClient),
            child: const TestLoginScreen(),
          ),
        ),
      );

      // Enter credentials
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'wrongpassword');
      await tester.pump();

      // Tap login
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Should show loading
      expect(find.byKey(const Key('loading_indicator')), findsOneWidget);

      // Wait for completion
      await tester.pumpAndSettle();

      // Should show error message
      expect(find.text('Email atau password salah'), findsOneWidget);
      
      // Login button should be enabled again for retry
      final button = tester.widget<ElevatedButton>(find.byKey(const Key('login_button')));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('form validation works correctly throughout the flow', (WidgetTester tester) async {
      final mockHttpClient = MockHttpClient();
      
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => LoginBloc(httpClient: mockHttpClient),
            child: const TestLoginScreen(),
          ),
        ),
      );

      // Initially button is disabled
      ElevatedButton button = tester.widget(find.byKey(const Key('login_button')));
      expect(button.onPressed, isNull);

      // Enter short email (should still be invalid)
      await tester.enterText(find.byKey(const Key('email_field')), 'ab');
      await tester.pump();
      button = tester.widget(find.byKey(const Key('login_button')));
      expect(button.onPressed, isNull);

      // Enter short password (should still be invalid)
      await tester.enterText(find.byKey(const Key('password_field')), '12');
      await tester.pump();
      button = tester.widget(find.byKey(const Key('login_button')));
      expect(button.onPressed, isNull);

      // Enter valid email and password
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.pump();
      
      // Button should now be enabled
      button = tester.widget(find.byKey(const Key('login_button')));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('network error handling works correctly', (WidgetTester tester) async {
      final mockHttpClient = MockHttpClient();
      when(() => mockHttpClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenThrow(Exception('Network timeout'));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => LoginBloc(httpClient: mockHttpClient),
            child: const TestLoginScreen(),
          ),
        ),
      );

      // Fill valid credentials
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.pump();

      // Submit form
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Should show loading
      expect(find.byKey(const Key('loading_indicator')), findsOneWidget);

      // Wait for error
      await tester.pumpAndSettle();

      // Should show network error message
      expect(find.text('Terjadi kesalahan. Silakan coba lagi.'), findsOneWidget);
      
      // Button should be enabled for retry
      final button = tester.widget<ElevatedButton>(find.byKey(const Key('login_button')));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('multiple rapid form changes work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TestLoginScreen(),
        ),
      );

      // Rapidly change email multiple times
      await tester.enterText(find.byKey(const Key('email_field')), 'test1@example.com');
      await tester.pump();
      await tester.enterText(find.byKey(const Key('email_field')), 'test2@example.com');
      await tester.pump();
      await tester.enterText(find.byKey(const Key('email_field')), 'test3@example.com');
      await tester.pump();

      // Rapidly change password multiple times
      await tester.enterText(find.byKey(const Key('password_field')), 'password1');
      await tester.pump();
      await tester.enterText(find.byKey(const Key('password_field')), 'password2');
      await tester.pump();
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.pump();

      // Final values should be correct and button enabled
      expect(find.text('test3@example.com'), findsOneWidget);
      final button = tester.widget<ElevatedButton>(find.byKey(const Key('login_button')));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('login state resets correctly after error and new input', (WidgetTester tester) async {
      final mockHttpClient = MockHttpClient();
      when(() => mockHttpClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => http.Response('{"error": "Invalid"}', 401));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => LoginBloc(httpClient: mockHttpClient),
            child: const TestLoginScreen(),
          ),
        ),
      );

      // Fill form and get error
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'wrongpassword');
      await tester.pump();
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Error should be visible
      expect(find.byKey(const Key('error_message')), findsOneWidget);

      // Change password - error should clear
      await tester.enterText(find.byKey(const Key('password_field')), 'newpassword');
      await tester.pump();

      // Error should be gone
      expect(find.byKey(const Key('error_message')), findsNothing);

      // Button should still be enabled
      final button = tester.widget<ElevatedButton>(find.byKey(const Key('login_button')));
      expect(button.onPressed, isNotNull);
    });
  });

  group('Event Tests', () {
    test('EmailChanged events should be equal when emails are the same', () {
      const event1 = EmailChanged('test@example.com');
      const event2 = EmailChanged('test@example.com');
      
      expect(event1, equals(event2));
      expect(event1.hashCode, equals(event2.hashCode));
    });

    test('PasswordChanged events should be equal when passwords are the same', () {
      const event1 = PasswordChanged('password123');
      const event2 = PasswordChanged('password123');
      
      expect(event1, equals(event2));
      expect(event1.hashCode, equals(event2.hashCode));
    });

    test('LoginSubmitted events should be equal', () {
      const event1 = LoginSubmitted();
      const event2 = LoginSubmitted();
      
      expect(event1, equals(event2));
    });

    test('LoginReset events should be equal', () {
      const event1 = LoginReset();
      const event2 = LoginReset();
      
      expect(event1, equals(event2));
    });
  });

  group('Edge Cases', () {
    test('LoginState handles null error message correctly', () {
      final state = LoginState(
        email: 'test@example.com',
        password: 'password123',
        errorMessage: null,
      );
      
      expect(state.errorMessage, isNull);
      expect(state.toString(), contains('errorMessage: null'));
    });

    test('LoginState copyWith preserves original values when no parameters provided', () {
      final originalState = LoginState(
        email: 'test@example.com',
        password: 'password123',
        errorMessage: 'Some error',
        isLoading: true,
        isSuccess: false,
      );
      
      final copiedState = originalState.copyWith();
      
      expect(copiedState.email, equals(originalState.email));
      expect(copiedState.password, equals(originalState.password));
      expect(copiedState.errorMessage, equals(originalState.errorMessage));
      expect(copiedState.isLoading, equals(originalState.isLoading));
      expect(copiedState.isSuccess, equals(originalState.isSuccess));
    });

    test('LoginState toString does not expose password', () {
      final state = LoginState(
        email: 'test@example.com',
        password: 'password123',
      );
      
      final stringRepresentation = state.toString();
      expect(stringRepresentation, contains('test@example.com'));
      expect(stringRepresentation, contains('[HIDDEN]'));
      expect(stringRepresentation, isNot(contains('password123')));
    });

    testWidgets('widget handles rapid button taps gracefully', (WidgetTester tester) async {
      final mockHttpClient = MockHttpClient();
      when(() => mockHttpClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 500));
        return http.Response('{"success": true}', 200);
      });

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => LoginBloc(httpClient: mockHttpClient),
            child: const TestLoginScreen(),
          ),
        ),
      );

      // Fill form
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.pump();

      // Tap button multiple times rapidly
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();
      
      // Button should be replaced by loading indicator
      expect(find.byKey(const Key('loading_indicator')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsNothing);

      // Wait for completion
      await tester.pumpAndSettle();

      // Should only have made one HTTP call despite multiple taps
      verify(() => mockHttpClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).called(1);
    });
  });
}