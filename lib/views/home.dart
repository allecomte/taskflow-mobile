import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/models/project/project.dart';
import 'package:taskflow_mobile/models/task/task.dart';
import 'package:taskflow_mobile/services/api/data/project_service.dart';
import 'package:taskflow_mobile/services/api/data/task_service.dart';
// import 'package:taskflow_mobile/services/api/data/user_service.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';
import 'package:taskflow_mobile/widgets/card_project.dart';
import 'package:taskflow_mobile/widgets/card_task.dart';
import 'package:taskflow_mobile/widgets/list_skeleton.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

enum LoadState { loading, success, error }

class HomeState extends State<Home> {
  LoadState projectsState = LoadState.loading;
  LoadState tasksState = LoadState.loading;

  List<Project> projects = [];
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final displayedProjects = projects.take(5).toList();
    final displayedTasks = tasks.take(5).toList();
    return Scaffold(
      bottomNavigationBar: BottomAppBarMenu(currentView: 'home'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                /* ----------------- COUNTER ----------------- */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Card.filled(
                        color: Theme.of(context).colorScheme.primary,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: projectsState == LoadState.loading
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                            ),
                                      )
                                    : projectsState == LoadState.error
                                    ? Icon(
                                        FontAwesomeIcons.triangleExclamation,
                                        size: 25,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      )
                                    : Text(
                                        '${projects.length}',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                              Text(
                                'Projects',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card.filled(
                        color: Theme.of(context).colorScheme.primary,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: tasksState == LoadState.loading
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                            ),
                                      )
                                    : tasksState == LoadState.error
                                    ? Icon(
                                        FontAwesomeIcons.triangleExclamation,
                                        size: 25,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      )
                                    : Text(
                                        '${tasks.length}',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                              Text(
                                'Tâches',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                /* ----------------- PROJECTS ----------------- */
                Padding(
                  padding: EdgeInsetsGeometry.directional(
                    top: 30,
                    start: 10,
                    end: 10,
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mes projets',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              FontAwesomeIcons.chevronRight,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      projectsState == LoadState.loading
                          ? ListSkeleton()
                          : projectsState == LoadState.error
                          ? Text(
                              'Erreur lors du chargement des projets',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            )
                          : projects.isEmpty ? Text("Vous n'avez aucun projet", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontStyle: FontStyle.italic)) : 
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: ((context,index) => CardProject(project: displayedProjects[index])),
                              itemCount: displayedProjects.length,
                            ),
                    ],
                  ),
                ),
                /* ----------------- RECENT TASKS ----------------- */
                Padding(
                  padding: EdgeInsetsGeometry.directional(
                    top: 30,
                    start: 10,
                    end: 10,
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mes tâches',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              FontAwesomeIcons.chevronRight,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      tasksState == LoadState.loading
                          ? ListSkeleton()
                          : tasksState == LoadState.error
                          ? Text(
                              'Erreur lors du chargement des tâches',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            )
                          : projects.isEmpty ? Text("Vous n'avez aucune tâche", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontStyle: FontStyle.italic)) : 
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: ((context,index) => CardTask(task: displayedTasks[index])),
                              itemCount: displayedTasks.length,
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getData() async {
    // final userService = UserService();
    // final user = await userService.getUserProfile();
    // print('User ID: ${user.id}');

    // TO SIMULATE LOADING TIME
    // Future.delayed(const Duration(seconds: 5), () async {
    //   final projectService = ProjectService();
    //   try {
    //     final dataProjects = await projectService.getProjects();
    //     setState(() {
    //       projects = dataProjects;
    //       projectsState = LoadState.success;
    //     });
    //   } catch (e) {
    //     setState(() {
    //       projectsState = LoadState.error;
    //     });
    //   }
    // });

    final projectService = ProjectService();
      try {
        final dataProjects = await projectService.getProjects();
        setState(() {
          projects = dataProjects;
          projectsState = LoadState.success;
        });
      } catch (e) {
        setState(() {
          projectsState = LoadState.error;
        });
      }

    final taskService = TaskService();
    try {
      final dataTasks = await taskService.getTasks();
      setState(() {
        tasks = dataTasks;
        tasksState = LoadState.success;
      });
    } catch (e) {
      setState(() {
        tasksState = LoadState.error;
      });
    }
  }
}
