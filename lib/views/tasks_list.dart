import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/enums/load_state.dart';
import 'package:taskflow_mobile/models/task/task_light.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';
import 'package:taskflow_mobile/services/api/data/task_service.dart';
import 'package:taskflow_mobile/views/task_form.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';
import 'package:taskflow_mobile/widgets/card_task.dart';
import 'package:taskflow_mobile/widgets/skeleton/list_skeleton.dart';

class TasksList extends ConsumerStatefulWidget {
  const TasksList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TasksListState();
}

class TasksListState extends ConsumerState<TasksList> {
  LoadState tasksState = LoadState.loading;
  List<TaskLight> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final taskService = TaskService();
    try {
      final dataTasks = await taskService.getTasks();
      setState(() {
        tasks = dataTasks.data;
        tasksState = LoadState.success;
      });
    } catch (e) {
      setState(() {
        tasksState = LoadState.error;
      });
    }
  }

  Future<void> refreshTasks() async {
    setState(() {
      tasksState = LoadState.loading;
    });
    await fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final isUserManager = user!.roles.contains('ROLE_MANAGER');
    return Scaffold(
      appBar: AppBarCurrentView(
        title: 'Mes tâches',
        actions: isUserManager
            ? [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskForm(),
                        ),
                      );
                    },
                    icon: Icon(
                      FontAwesomeIcons.circlePlus,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
              ]
            : [],
      ),
      bottomNavigationBar: BottomAppBarMenu(currentView: 'task'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshTasks,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: tasksState == LoadState.loading
                  ? ListSkeleton(itemCount: 10)
                  : tasksState == LoadState.error
                  ? Text(
                      'Erreur lors du chargement des tâches',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
                  : tasks.isEmpty
                  ? Text(
                      "Vous n'avez à aucune tâche",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) =>
                          CardTask(task: tasks[index])),
                      itemCount: tasks.length,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
