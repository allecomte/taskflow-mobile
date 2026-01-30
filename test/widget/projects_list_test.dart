import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/models/project/project_light.dart';
import 'package:taskflow_mobile/models/user/user_light.dart';
import 'package:taskflow_mobile/providers/services/project_service_provider.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';
import 'package:taskflow_mobile/services/api/data/project_service.dart';
import 'package:taskflow_mobile/views/projects_list.dart';
import 'package:taskflow_mobile/widgets/card_project.dart';
// Fakes
import '../fakes/fake_project_service.dart';
import '../fakes/fake_user_notifier.dart';

Widget createWidgetUnderTest({
  required ProjectService projectService,
  required List<String> roles,
}) {
  return ProviderScope(
    overrides: [
      projectServiceProvider.overrideWithValue(projectService),
      userProvider.overrideWith(
        (ref) => FakeUserNotifier(
          UserLight(
            id: '1',
            email: 'jdoe@test.com',
            firstname: 'John',
            lastname: 'Doe',
            roles: roles,
          ),
        ),
      ),
    ],
    child: const MaterialApp(home: ProjectsList()),
  );
}

void main() {
  testWidgets('display projects\' list', (tester) async {
    final service = FakeProjectService(
      () async => [
        ProjectLight(
          id: '6910cdae413899315e37d31d',
          title: 'Project One',
          description: "Description for Project One",
          startAt: "2025-01-01T00:00:00.000+00:00",
        ),
        ProjectLight(
          id: '6910cdae413899315e37d31e',
          title: 'Project Two',
          description: "Description for Project Two",
          startAt: "2026-01-01T00:00:00.000+00:00",
        ),
      ],
    );
    await tester.pumpWidget(
      createWidgetUnderTest(projectService: service, roles: ['ROLE_MANAGER']),
    );

    await tester.pumpAndSettle();

    expect(find.byType(CardProject), findsNWidgets(2));
  });

  testWidgets('display error when API call fails', (tester) async {
    final service = FakeProjectService(
      () async => throw Exception('API error'),
    );

    await tester.pumpWidget(
      createWidgetUnderTest(projectService: service, roles: ['ROLE_USER']),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(Key('error_loading_projects_message')), findsOneWidget);
  });

  testWidgets('display message when no project is returned', (tester) async {
    final service = FakeProjectService(() async => []);

    await tester.pumpWidget(
      createWidgetUnderTest(projectService: service, roles: ['ROLE_USER']),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(Key('no_project_message')), findsOneWidget);
  });

  testWidgets('display button to create project for a manager', (tester) async {
    final service = FakeProjectService(() async => []);

    await tester.pumpWidget(
      createWidgetUnderTest(projectService: service, roles: ['ROLE_MANAGER']),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(FontAwesomeIcons.circlePlus), findsOneWidget);
  });
}
