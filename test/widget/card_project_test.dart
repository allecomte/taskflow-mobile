import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow_mobile/models/task/task.dart';
import 'package:taskflow_mobile/widgets/card_project.dart';
import 'package:taskflow_mobile/models/project/project_light.dart';

void main() {
  group('CardProject Widget', () {
    testWidgets('displays project title and correct subtitle', (tester) async {
      final projectWithNoTasks = ProjectLight(
        id: '1',
        title: 'Projet A',
        myTasks: [],
        description: '',
        startAt: '2026-01-31T12:00:00.720Z',
      );
      final projectWithTasks = ProjectLight(
        id: '2',
        title: 'Projet B',
        myTasks: [
          Task(
            id: '1',
            title: 'title',
            state: 'OPEN',
            priority: 'HIGH',
            dueAt: '2026-08-31T12:00:00.720Z',
          ),
          Task(
            id: '2',
            title: 'title',
            state: 'OPEN',
            priority: 'HIGH',
            dueAt: '2026-08-31T12:00:00.720Z',
          ),
        ],
        description: '',
        startAt: '',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              CardProject(project: projectWithNoTasks),
              CardProject(project: projectWithTasks),
            ],
          ),
        ),
      );

      // Vérifie les titres
      expect(find.text('Projet A'), findsOneWidget);
      expect(find.text('Projet B'), findsOneWidget);

      // Vérifie les subtitles
      expect(find.text('Aucune tâche assignée'), findsOneWidget);
      expect(find.text('2 tâches assignées'), findsOneWidget);
    });
  });
}
