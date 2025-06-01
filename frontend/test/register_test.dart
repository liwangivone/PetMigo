import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/views/pages/pages.dart';

void main() {
  testWidgets('RegisterScreen widget test', (WidgetTester tester) async {
    // 1. Render widget RegisterScreen
    await tester.pumpWidget(
      MaterialApp(
        home: RegisterScreen(),
      ),
    );

    // 2. Verifikasi ada teks utama
    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('Full name *'), findsOneWidget);
    expect(find.text('Password *'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);

    // 3. Masukkan nama lengkap
    await tester.enterText(find.byType(TextField).at(0), 'Ivone Liwang');
    expect(find.text('Ivone Liwang'), findsOneWidget);

    // 4. Masukkan email
    await tester.enterText(find.byType(TextField).at(1), 'ivone@example.com');
    expect(find.text('ivone@example.com'), findsOneWidget);

    // 5. Masukkan password
    await tester.enterText(find.byType(TextField).at(2), 'password123');
    expect(find.text('password123'), findsOneWidget);

    // 6. Centang checkbox
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    // 7. Tekan tombol Create Account
    final button = find.widgetWithText(ElevatedButton, 'Create account');
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pump();

    // Catatan: Navigasi ke login tidak bisa dites langsung tanpa mock router
  });
}
