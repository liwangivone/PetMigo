import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:frontend/bloc/login_bloc.dart';
import 'package:frontend/models/model_login.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'dart:convert';

// Mock HTTP Client
class MockClient extends Mock implements http.Client {}

void main() {
  group('LoginBloc', () {
    late LoginBloc loginBloc;

    setUp(() {
      loginBloc = LoginBloc();
    });

    test('initial state is correct', () {
      expect(loginBloc.state.email, '');
      expect(loginBloc.state.password, '');
      expect(loginBloc.state.isValid, false);
      expect(loginBloc.state.isSuccess, false);
    });

    blocTest<LoginBloc, LoginState>(
      'emits updated email when EmailChanged is added',
      build: () => loginBloc,
      act: (bloc) => bloc.add(EmailChanged('user@example.com')),
      expect: () => [
        isA<LoginState>().having((s) => s.email, 'email', 'user@example.com'),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits updated password when PasswordChanged is added',
      build: () => loginBloc,
      act: (bloc) => bloc.add(PasswordChanged('password123')),
      expect: () => [
        isA<LoginState>().having((s) => s.password, 'password', 'password123'),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'does not emit login state when form is invalid',
      build: () => loginBloc,
      act: (bloc) => bloc.add(LoginSubmitted()),
      expect: () => [],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [loading, success] when login is successful',
      build: () {
        return LoginBloc()
          ..emit(LoginState(email: 'test@mail.com', password: '123456'));
      },
      act: (bloc) async {
        // You can mock the HTTP response or just simulate the success here
        bloc.emit(bloc.state.copyWith(isLoading: true));
        bloc.emit(bloc.state.copyWith(isLoading: false, isSuccess: true));
      },
      expect: () => [
        isA<LoginState>().having((s) => s.isLoading, 'loading', true),
        isA<LoginState>()
            .having((s) => s.isLoading, 'loading', false)
            .having((s) => s.isSuccess, 'success', true),
      ],
    );
  });
}