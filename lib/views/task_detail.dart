import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// Enums
import 'package:taskflow_mobile/enums/task_priority.dart';
import 'package:taskflow_mobile/enums/task_state.dart';
import 'package:taskflow_mobile/models/tag/tag.dart';
// Models
import 'package:taskflow_mobile/models/task/task_detailed.dart';
import 'package:taskflow_mobile/models/task/task_light.dart';
import 'package:taskflow_mobile/models/user/user.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';
import 'package:taskflow_mobile/services/api/data/tag_service.dart';
import 'package:taskflow_mobile/services/api/data/task_service.dart';
import 'package:taskflow_mobile/utils/format_date.dart';
import 'package:taskflow_mobile/utils/snackbar_global.dart';
// Views
import 'package:taskflow_mobile/views/home.dart';
import 'package:taskflow_mobile/views/task_form.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';
import 'package:taskflow_mobile/widgets/bottom_sheet/associate_tag_to_task_bottom_sheet.dart';
import 'package:taskflow_mobile/widgets/bottom_sheet/remove_tag_from_task_bottom_sheet.dart';
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
    if(tagAssociated == null) return;
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
    try{
      final tagService = TagService();
      await tagService.associateOrDissociateTagWithTask(taskId: widget.taskLight.id, tagId: tag.id);
      if(toAssociate){
        setState(() {
          tags.add(tag);
        });
      }else{
        setState(() {
          tags.remove(tag);
        });
      }
      if (!mounted) return;
      SnackbarGlobal.showSuccess('Tag ${toAssociate ?  'associé à':'retiré de'} la tâche');
    }catch (e) {
      SnackbarGlobal.showError('Erreur lors ${toAssociate ?  'l\'association ':'du retrait'} du tag');
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
                  Text(
                    'État : ${TaskState.values.firstWhere((state) => state.value == task.state).label}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
                  taskState == LoadState.loading ? SmallListSkeleton() : taskState == LoadState.error ? Text(
                          'Erreur lors du chargement des tags',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ): tags.isEmpty
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
