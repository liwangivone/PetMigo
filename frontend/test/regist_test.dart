import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/bloc/regist_bloc.dart'; // ganti path sesuai
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('RegisterBloc', () {
    late RegisterBloc bloc;

    setUp(() {
      bloc = RegisterBloc();
    });

    test('initial state is empty and invalid', () {
      expect(bloc.state.email, '');
      expect(bloc.state.password, '');
      expect(bloc.state.name, '');
      expect(bloc.state.agreed, false);
      expect(bloc.state.isValid, false);
    });

    blocTest<RegisterBloc, RegisterState>(
      'emits invalid when email and password are empty',
      build: () => bloc,
      act: (bloc) {
        bloc.add(RegisterEmailChanged(''));
        bloc.add(RegisterPasswordChanged(''));
        bloc.add(RegisterNameChanged(''));
        bloc.add(RegisterTermsToggled());
        bloc.add(RegisterTermsToggled());
      },
      expect: () => [
        isA<RegisterState>().having((s) => s.isValid, 'isValid', false),
        isA<RegisterState>().having((s) => s.isValid, 'isValid', false),
        isA<RegisterState>().having((s) => s.isValid, 'isValid', false),
        isA<RegisterState>().having((s) => s.agreed, 'agreed', true),
        isA<RegisterState>().having((s) => s.agreed, 'agreed', false),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      'isValid remains false when email is missing @gmail.com',
      build: () => bloc,
      act: (bloc) {
        bloc.add(RegisterEmailChanged('notgmail.com'));
        bloc.add(RegisterNameChanged('Nama Lengkap'));
        bloc.add(RegisterPasswordChanged('12345678'));
        bloc.add(RegisterTermsToggled());
      },
      expect: () => [
        isA<RegisterState>().having((s) => s.email, 'email', 'notgmail.com').having((s) => s.isValid, 'isValid', false),
        isA<RegisterState>(),
        isA<RegisterState>(),
        isA<RegisterState>().having((s) => s.isValid, 'isValid', false),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      'isValid is false if password too short',
      build: () => bloc,
      act: (bloc) {
        bloc.add(RegisterEmailChanged('test@gmail.com'));
        bloc.add(RegisterNameChanged('Test'));
        bloc.add(RegisterPasswordChanged('123'));
        bloc.add(RegisterTermsToggled());
      },
      expect: () => [
        isA<RegisterState>(),
        isA<RegisterState>(),
        isA<RegisterState>().having((s) => s.password, 'password', '123'),
        isA<RegisterState>().having((s) => s.isValid, 'isValid', false),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      'isValid is false if terms not agreed',
      build: () => bloc,
      act: (bloc) {
        bloc.add(RegisterEmailChanged('test@gmail.com'));
        bloc.add(RegisterNameChanged('Test'));
        bloc.add(RegisterPasswordChanged('12345678'));
        // terms not toggled!
      },
      expect: () => [
        isA<RegisterState>(),
        isA<RegisterState>(),
        isA<RegisterState>().having((s) => s.isValid, 'isValid', false),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      'isValid becomes true when all fields valid',
      build: () => bloc,
      act: (bloc) {
        bloc.add(RegisterEmailChanged('test@gmail.com'));
        bloc.add(RegisterNameChanged('Test Name'));
        bloc.add(RegisterPasswordChanged('12345678'));
        bloc.add(RegisterTermsToggled());
      },
      expect: () => [
        isA<RegisterState>(),
        isA<RegisterState>(),
        isA<RegisterState>(),
        isA<RegisterState>().having((s) => s.isValid, 'isValid', true),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      'does not call API if form is invalid on RegisterSubmitted',
      build: () => bloc,
      act: (bloc) => bloc.add(RegisterSubmitted()),
      expect: () => [], // tidak ada state baru karena print doang
    );
  });
}
