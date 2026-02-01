import 'package:flutter/material.dart';
import 'package:taskflow_mobile/models/task/task_light.dart';
import 'package:taskflow_mobile/utils/format_date.dart';
import 'package:taskflow_mobile/views/task_detail.dart';

class CardTask extends StatelessWidget {
  final TaskLight task;
  final bool displayAssignee;
  const CardTask({super.key, required this.task, this.displayAssignee = false});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: ListTile(
        // leading: Icon(
        //   FontAwesomeIcons.solidFolder,
        //   color: Theme.of(context).colorScheme.primary,
        // ),
        title: Text(
          task.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Échéance : ${formatDateFr(task.dueAt)}',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            if (displayAssignee)
              task.assignee != null
                  ? Text(
                      'Assignée à ${task.assignee?.firstname} ${task.assignee?.lastname}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : Text(
                      'Aucune personne n\'est assigné à tâche',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
          ],
        ),
        // trailing: Icon(FontAwesomeIcons.chevronRight),
        onTap: (){
          MaterialPageRoute route = MaterialPageRoute(builder: (context) => TaskDetail(taskLight: task));
          Navigator.of(context).push(route);
        },
      ),
    );
  }
}
