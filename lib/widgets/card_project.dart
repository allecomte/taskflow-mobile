import 'package:flutter/material.dart';
import 'package:taskflow_mobile/models/project/project.dart';

class CardProject extends StatelessWidget{
  final Project project;
  const CardProject({super.key, required this.project});
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
                                      project.title,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${project.id} tâches assignées',
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