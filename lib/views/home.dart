import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// Enums
// import 'package:taskflow_mobile/enums/load_state.dart';
// Models
import 'package:taskflow_mobile/models/project/project.dart';
import 'package:taskflow_mobile/models/task/task.dart';
// Services
import 'package:taskflow_mobile/services/api/data/project_service.dart';
import 'package:taskflow_mobile/services/api/data/task_service.dart';
import 'package:taskflow_mobile/views/projects_list.dart';
// import 'package:taskflow_mobile/services/api/data/user_service.dart';
// Widgets
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

  int numberOfProjects = 0;
  int numberOfTasks = 0;

  int numberOfItemsToDisplay = 5;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
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
                                        numberOfProjects.toString(),
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
                                        numberOfTasks.toString(),
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
                        onTap: () {
                          MaterialPageRoute route = MaterialPageRoute(builder: (context) => const ProjectsList());
                          Navigator.of(context).push(route);
                        },
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
                              itemBuilder: ((context,index) => CardProject(project: projects[index])),
                              itemCount: projects.length < numberOfItemsToDisplay ? projects.length : numberOfItemsToDisplay,
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
                          : tasks.isEmpty ? Text("Vous n'avez aucune tâche", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontStyle: FontStyle.italic)) : 
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: ((context,index) => CardTask(task: tasks[index])),
                              itemCount: tasks.length < numberOfItemsToDisplay ? tasks.length : numberOfItemsToDisplay,
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
        final dataProjects = await projectService.getProjects(pagination: true, limit: numberOfItemsToDisplay, page: 1, getAlsoArchived: false, sort: '-createdAt');
        setState(() {
          projects = dataProjects.data;
          numberOfProjects = dataProjects.pagination.total;
          projectsState = LoadState.success;
        });
      } catch (e) {
        setState(() {
          projectsState = LoadState.error;
        });
      }

    final taskService = TaskService();
    try {
      final dataTasks = await taskService.getTasks(pagination: true, limit: numberOfItemsToDisplay, page: 1, notClosed: true, sort: '-dueAt');
      setState(() {
        tasks = dataTasks.data;
        numberOfTasks = dataTasks.pagination.total;
        tasksState = LoadState.success;
      });
    } catch (e) {
      setState(() {
        tasksState = LoadState.error;
      });
    }
  }
}
