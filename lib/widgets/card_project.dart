import 'package:flutter/material.dart';
import 'package:taskflow_mobile/models/project/project_light.dart';
import 'package:taskflow_mobile/views/project_detail.dart';

class CardProject extends StatelessWidget {
  final ProjectLight project;
  const CardProject({super.key, required this.project});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.primary.withAlpha(80),
      elevation: 2,
      child: ListTile(
        title: Text(
          project.title,
          style: TextStyle(
            color: isDark ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: project.myTasks.isEmpty
            ? Text(
                'Aucune tâche assignée',
                style: TextStyle(
                  color: isDark ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.primary,
                  fontStyle: FontStyle.italic,
                ),
              )
            : Text(
                '${project.myTasks.length} ${project.myTasks.length > 1 ? 'tâches assignées' : 'tâche assignée'}',
                style: TextStyle(
                  color: isDark ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.primary,
                ),
              ),
        onTap: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => ProjectDetail(projectLight: project),
          );
          Navigator.of(context).push(route);
        },
      ),
    );
  }
}
