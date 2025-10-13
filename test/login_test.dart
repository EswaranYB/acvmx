import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:acvmx/feature/auth/view/screens/login.dart';
import 'package:acvmx/feature/auth/controller/auth_controller.dart';

void main() {
  testWidgets('LoginPage renders and responds to input', (WidgetTester tester) async {
    final authController = AuthController();

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthController>.value(
        value: authController,
        child: MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    // Verify the presence of username and password fields (assuming TextField or TextFormField).
    expect(find.byType(TextField), findsNWidgets(2)); // or use TextFormField if applicable
    expect(find.text('Login'), findsOneWidget);

    // Simulate user input.
    await tester.enterText(find.byType(TextField).first, 'testuser');
    await tester.enterText(find.byType(TextField).last, 'password123');

    // Verify input values are displayed.
    expect(find.text('testuser'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);

    // Tap login button.
    await tester.tap(find.text('Login'));
    await tester.pump(); // triggers rebuild
  });
}
