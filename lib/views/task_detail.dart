import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/models/task/task_detailed.dart';
import 'package:taskflow_mobile/models/task/task_light.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';
import 'package:taskflow_mobile/services/api/data/task_service.dart';
import 'package:taskflow_mobile/utils/format_date.dart';
import 'package:taskflow_mobile/views/home.dart';
import 'package:taskflow_mobile/views/task_form.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';
import 'package:taskflow_mobile/widgets/skeleton/line_skeleton.dart';

class TaskDetail extends ConsumerStatefulWidget {
  final TaskLight taskLight;
  const TaskDetail({super.key, required this.taskLight});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TaskDetailState();
}

class TaskDetailState extends ConsumerState<TaskDetail> {
  LoadState taskState = LoadState.loading;
  TaskDetailed? taskDetail;
  String? description;

  @override
  void initState() {
    super.initState();
    fetchTask();
  }

  Future<void> refetchTask() async {
    await fetchTask();
  }

  Future<void> fetchTask() async {
    final taskService = TaskService();
    try {
      final task = await taskService.getTaskById(widget.taskLight.id);
      setState(() {
        taskDetail = task;
        description = task.description;
        taskState = LoadState.success;
      });
    } catch (e) {
      setState(() {
        taskState = LoadState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final task = taskDetail ?? widget.taskLight;
    final isUserManager = user!.roles.contains('ROLE_MANAGER');
    bool isUserOwner = false;
    if (taskDetail != null) {
      isUserOwner = user.projectsOwned.contains(taskDetail!.project.id);
    }

    return Scaffold(
      appBar: AppBarCurrentView(
        title: task.title,
        actions: taskDetail != null && isUserManager && isUserOwner
            ? [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskForm(task: taskDetail!),
                        ),
                      );
                    },
                    icon: Icon(
                      FontAwesomeIcons.penToSquare,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
              ]
            : [],
      ),
      bottomNavigationBar: BottomAppBarMenu(currentView: 'project'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refetchTask,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  taskState == LoadState.loading
                      ? LineSkeleton()
                      : taskState == LoadState.error || description == null
                      ? Text(
                          'Erreur lors du chargement des donnés',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                      : Text(description!),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.calendar,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Échéance : ${formatDateFr(task.dueAt)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
