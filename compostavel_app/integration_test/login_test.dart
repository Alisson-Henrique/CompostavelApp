import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:integration_test/integration_test.dart';

import 'package:compostavel_app/main.dart' as app;

void main() {
  //IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Finds the floating action button to tap on.
      final buttonLogin = find.byKey(ValueKey('ButtonLogin'));

      // Emulate a tap on the floating action button.
      await tester.tap(buttonLogin);

      // Trigger a frame.
      await tester.pumpAndSettle();

      // Verify the counter increments by 1.
      expect(find.text('Email Inválido.'), findsOneWidget);
    });
  });
}
