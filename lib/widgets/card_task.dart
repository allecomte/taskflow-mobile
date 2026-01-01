import 'package:flutter/material.dart';
import 'package:taskflow_mobile/models/task/task.dart';

class CardTask extends StatelessWidget{
  final Task task;
  const CardTask({super.key, required this.task});
  @override
  Widget build(BuildContext context) {
    return Card(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryFixed,
                                  child: ListTile(
                                    // leading: Icon(
                                    //   FontAwesomeIcons.solidFolder,
                                    //   color: Theme.of(context).colorScheme.primary,
                                    // ),
                                    title: Text(
                                      task.title,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'échéance : ${task.dueAt}',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                    // trailing: Icon(FontAwesomeIcons.chevronRight),
                                  ),
                                );
  }

}