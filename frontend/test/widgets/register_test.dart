// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:frontend/bloc/regist_bloc.dart';
// import 'package:frontend/views/pages/pages.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// void main() {
//   testWidgets('RegisterScreen widget test with real login navigation', (WidgetTester tester) async {
//     final router = GoRouter(
//       routes: [
//         GoRoute(
//           path: '/',
//           builder: (context, state) => const RegisterScreen(),
//         ),
//         GoRoute(
//           path: '/login',
//           builder: (context, state) => const LoginScreen(),
//         ),
//       ],
//     );

//     Widget makeTestableWidget() {
//       return BlocProvider<RegisterBloc>(
//         create: (_) => RegisterBloc(),
//         child: MaterialApp.router(
//           routerDelegate: router.routerDelegate,
//           routeInformationParser: router.routeInformationParser,
//           routeInformationProvider: router.routeInformationProvider, 
//         ),
//       );
//     }

//     await tester.pumpWidget(makeTestableWidget());

//     expect(find.text('Create your account'), findsOneWidget);
//     expect(find.text('Full name *'), findsOneWidget);
//     expect(find.byType(TextField), findsNWidgets(3));
//     expect(find.text('Create account'), findsOneWidget);

//     await tester.tap(find.text('Login'));
//     await tester.pumpAndSettle();

//     expect(find.text('Login'), findsOneWidget);
//   });
// }
