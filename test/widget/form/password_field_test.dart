import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow_mobile/widgets/form/password_field.dart';

void main() {
  group('PasswordField Widget', () {
    late TextEditingController passwordController;
    late TextEditingController confirmController;

    setUp(() {
      passwordController = TextEditingController();
      confirmController = TextEditingController();
    });

    tearDown(() {
      passwordController.dispose();
      confirmController.dispose();
    });

    testWidgets('displays TextFormField with correct label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordField(
              passwordController: passwordController,
              label: 'Mot de passe',
            ),
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);

      expect(find.text('Mot de passe'), findsOneWidget);
    });

    testWidgets('toggles password visibility when icon is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordField(
              passwordController: passwordController,
              label: 'Mot de passe',
            ),
          ),
        ),
      );

      final iconButton = find.byType(IconButton);
      expect(iconButton, findsOneWidget);

      // Vérifie que l'icône initiale est visibility_off
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap sur l'icône pour afficher le mot de passe
      await tester.tap(iconButton);
      await tester.pumpAndSettle();

      // Vérifie que l'icône a changé
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // Tap de nouveau pour masquer
      await tester.tap(iconButton);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('validator returns correct errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: Column(
                children: [
                  PasswordField(
                    passwordController: passwordController,
                    confirmController: confirmController,
                    label: 'Mot de passe',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final formState = find.byType(Form);
      expect(formState, findsOneWidget);

      // Test champ vide
      expect(
        (tester
            .widget<TextFormField>(find.byType(TextFormField))
            .validator
            ?.call('')),
        'Le mot de passe est requis',
      );

      // Test moins de 8 caractères
      expect(
        (tester
            .widget<TextFormField>(find.byType(TextFormField))
            .validator
            ?.call('1234567')),
        'Minimum 8 caractères',
      );

      // Test confirmation différente
      passwordController.text = '12345678';
      confirmController.text = '87654321';
      expect(
        (tester
            .widget<TextFormField>(find.byType(TextFormField))
            .validator
            ?.call('12345678')),
        'Les mots de passe renseignés doivent être identiques',
      );

      // Test valid
      confirmController.text = '12345678';
      expect(
        (tester
            .widget<TextFormField>(find.byType(TextFormField))
            .validator
            ?.call('12345678')),
        null,
      );
    });
  });
}
