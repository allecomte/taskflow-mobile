import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow_mobile/widgets/bottom_sheet/add_tag_bottom_sheet.dart';

class MockNavigatorObserver extends NavigatorObserver {
  List<Route<dynamic>> pushedRoutes = [];

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    pushedRoutes.add(route);
  }
}

void main() {
  group('AddTagBottomSheet Widget', () {
    testWidgets('displays form elements', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTagBottomSheet(),
          ),
        ),
      );

      expect(find.text('Ajouter un tag'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Ajouter'), findsOneWidget);
      expect(find.byIcon(Icons.tag), findsNothing); // Icon de FontAwesome, on ne teste pas le type exact
    });

    testWidgets('shows validation error when empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTagBottomSheet(),
          ),
        ),
      );

      // Tap sur le bouton "Ajouter" sans rien remplir
      await tester.tap(find.text('Ajouter'));
      await tester.pumpAndSettle();

      expect(find.text('Veuillez entrer un nom de tag'), findsOneWidget);
    });

    testWidgets('pops with trimmed value when valid', (tester) async {
      String? poppedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () async {
                    poppedValue = await showModalBottomSheet<String>(
                      context: context,
                      builder: (_) => AddTagBottomSheet(),
                    );
                  },
                  child: Text('Open Bottom Sheet'),
                ),
              );
            },
          ),
        ),
      );

      // Ouvrir la bottom sheet
      await tester.tap(find.text('Open Bottom Sheet'));
      await tester.pumpAndSettle();

      // Remplir le champ
      await tester.enterText(find.byType(TextFormField), '  MonTag  ');

      // Tap sur Ajouter
      await tester.tap(find.text('Ajouter'));
      await tester.pumpAndSettle();

      expect(poppedValue, 'MonTag'); // la valeur est trimée
    });
  });
}
