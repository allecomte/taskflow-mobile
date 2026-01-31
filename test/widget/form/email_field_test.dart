import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow_mobile/widgets/form/email_field.dart';

void main() {
  group('EmailField Widget', () {
    late TextEditingController emailController;

    setUp(() {
      emailController = TextEditingController();
    });

    tearDown(() {
      emailController.dispose();
    });

    testWidgets('displays TextFormField with correct label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmailField(emailController: emailController),
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      expect(find.text('Adresse mail'), findsOneWidget);
    });

    testWidgets('validator returns correct errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: EmailField(emailController: emailController),
            ),
          ),
        ),
      );

      final textFormField = tester.widget<TextFormField>(find.byType(TextFormField));

      // Champ vide
      expect(textFormField.validator?.call(''), 'L’email est requis');

      // Format invalide
      expect(textFormField.validator?.call('test'), 'Format d’email invalide');
      expect(textFormField.validator?.call('test@'), 'Format d’email invalide');
      expect(textFormField.validator?.call('test@test'), 'Format d’email invalide');

      // Format valide
      expect(textFormField.validator?.call('test@test.com'), null);
    });
  });
}
