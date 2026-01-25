import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/enums/load_state.dart';
// Enums
import 'package:taskflow_mobile/enums/task_priority.dart';
import 'package:taskflow_mobile/enums/task_state.dart';
import 'package:taskflow_mobile/models/tag/tag.dart';
// Models
import 'package:taskflow_mobile/models/task/task_detailed.dart';
import 'package:taskflow_mobile/models/task/task_light.dart';
import 'package:taskflow_mobile/models/user/user.dart';
import 'package:taskflow_mobile/providers/tasks_list_provider.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';
import 'package:taskflow_mobile/services/api/data/tag_service.dart';
import 'package:taskflow_mobile/services/api/data/task_service.dart';
import 'package:taskflow_mobile/utils/format_date.dart';
import 'package:taskflow_mobile/utils/snackbar_global.dart';
// Views
import 'package:taskflow_mobile/views/task_form.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';
import 'package:taskflow_mobile/widgets/bottom_sheet/associate_tag_to_task_bottom_sheet.dart';
import 'package:taskflow_mobile/widgets/bottom_sheet/remove_tag_from_task_bottom_sheet.dart';
import 'package:taskflow_mobile/widgets/bottom_sheet/update_state_task_bottom_sheet.dart';
import 'package:taskflow_mobile/widgets/chip_tag.dart';
import 'package:taskflow_mobile/widgets/skeleton/line_skeleton.dart';
import 'package:taskflow_mobile/widgets/skeleton/small_list_skeleton.dart';

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
  User? assignee;
  List<Tag> tags = [];

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
        assignee = task.assignee;
        tags = task.tags;
        taskState = LoadState.success;
      });
    } catch (e) {
      setState(() {
        taskState = LoadState.error;
      });
    }
  }

  Future<void> _onAssociateTagPressed() async {
    final tagAssociated = await showModalBottomSheet<Tag>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AssociateTagToTaskBottomSheet(taskDetail: taskDetail!),
    );
    if (tagAssociated == null) return;
    _associateOrRemoveTag(tagAssociated, true);
  }

  Future<void> _onRemoveTagPressed(Tag tag) async {
    final confirm = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => RemoveTagFromTaskBottomSheet(tagName: tag.name),
    );

    if (confirm == true) {
      _associateOrRemoveTag(tag, false);
    }
  }

  Future<void> _associateOrRemoveTag(Tag tag, bool toAssociate) async {
    try {
      final tagService = TagService();
      await tagService.associateOrDissociateTagWithTask(
        taskId: widget.taskLight.id,
        tagId: tag.id,
      );
      if (toAssociate) {
        setState(() {
          tags.add(tag);
        });
      } else {
        setState(() {
          tags.remove(tag);
        });
      }
      if (!mounted) return;
      SnackbarGlobal.showSuccess(
        'Tag ${toAssociate ? 'associé à' : 'retiré de'} la tâche',
      );
    } catch (e) {
      SnackbarGlobal.showError(
        'Erreur lors ${toAssociate ? 'l\'association ' : 'du retrait'} du tag',
      );
    }
  }

  Future<void> _onUpdateStatePressed(String stateValue) async {
    final newState = await showModalBottomSheet<TaskState>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => UpdateStateTaskBottomSheet(state: TaskState.values.firstWhere((priority) => priority.value == stateValue)),
    );
    if (newState == null) return;
    _updateTaskState(newState);
  }

  Future<void> _updateTaskState(TaskState state) async {
    final taskService = TaskService();
    try {
      await taskService.updateTaskState(id: widget.taskLight.id, state: state.value);
      if (!mounted) return;
      SnackbarGlobal.showSuccess(
        'Priorité de la tâche mise à jour avec succès',
      );
      if(taskDetail != null){
        setState(() {
          taskDetail = taskDetail!.copyWith(state: state.value);
        });
      }
    } catch (e) {
      if (!mounted) return;
      SnackbarGlobal.showError('Erreur lors de la mise à jour de la priorité');
    }
  }

  Future<void> _onDeleteTaskPressed() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                FontAwesomeIcons.trash,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Expanded(
              child: Text(
                'Confirmer la suppression',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer cette tâche ?',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            child: Text(
              'Supprimer',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      _deleteTask();
    }
  }

  Future<void> _deleteTask() async {
    final taskService = TaskService();
    try {
      await taskService.deleteTask(taskId: widget.taskLight.id);
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ref.read(tasksListProvider.notifier).refresh();
      SnackbarGlobal.showSuccess(
        'Tâche ${widget.taskLight.title} supprimée avec succès',
      );
    } catch (e) {
      if (!mounted) return;
      SnackbarGlobal.showError('Erreur lors de la suppression de la tâche');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final task = taskDetail ?? widget.taskLight;
    final isUserManager = user!.roles.contains('ROLE_MANAGER');
    bool isUserOwner = false;
    bool isUserAssignee = false;
    if (taskDetail != null) {
      isUserOwner = user.projectsOwned.contains(taskDetail!.project.id);
      isUserAssignee = user.id == taskDetail!.assignee.id;
    }

    return Scaffold(
      appBar: AppBarCurrentView(
        title: task.title,
        actions: taskDetail != null && isUserManager && isUserOwner
            ? [
                IconButton(
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
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: _onDeleteTaskPressed,
                    icon: Icon(
                      FontAwesomeIcons.trash,
                      color: Theme.of(context).colorScheme.error,
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
          onRefresh: refetchTask,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  taskState == LoadState.loading
                      ? LineSkeleton(context: context)
                      : taskState == LoadState.error || description == null
                      ? Text(
                          'Erreur lors du chargement des donnés',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                      : Text(
                          description!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                  SizedBox(height: 20),
                  // ------------------------------- DUE AT
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
                  SizedBox(height: 20),
                  // ------------------------------- PRIORITY
                  Text(
                    'Priorité : ${TaskPriority.values.firstWhere((priority) => priority.value == task.priority).label}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 10),
                  // ------------------------------- STATE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'État : ${TaskState.values.firstWhere((state) => state.value == task.state).label}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      isUserAssignee ?
                      IconButton(
                        onPressed: () => _onUpdateStatePressed(task.state),
                        icon: Icon(
                          FontAwesomeIcons.penToSquare,
                          color: Theme.of(context).colorScheme.primary,
                          size: 16,
                        ),
                      ) : SizedBox.shrink(),
                    ],
                  ),
                  SizedBox(height: 10),
                  // ------------------------------- ASSIGNEE
                  taskState == LoadState.loading
                      ? LineSkeleton(context: context)
                      : taskState == LoadState.error || assignee == null
                      ? Text(
                          'Erreur lors du chargement des donnés',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                      : Text(
                          'Assignée : ${assignee!.firstname} ${assignee!.lastname}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                  SizedBox(height: 20),
                  // ------------------------------- TAG
                  Text(
                    'Tags',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  taskState == LoadState.loading
                      ? SmallListSkeleton()
                      : taskState == LoadState.error
                      ? Text(
                          'Erreur lors du chargement des tags',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                      : tags.isEmpty
                      ? Text(
                          "Le projet ne possède aucun tag.",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tags.map((tag) {
                            return ChipTag(
                              tag: tag,
                              onDelete: _onRemoveTagPressed,
                            );
                          }).toList(),
                        ),
                  SizedBox(height: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: taskDetail != null ? _onAssociateTagPressed : null,
                    child: Chip(
                      label: Text(
                        'Associer un tag',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                      avatar: Icon(
                        FontAwesomeIcons.plus,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
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
