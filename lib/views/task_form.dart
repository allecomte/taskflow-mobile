import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Enums
import 'package:taskflow_mobile/enums/load_state.dart';
import 'package:taskflow_mobile/enums/task_priority.dart';
// Models
import 'package:taskflow_mobile/models/project/project_detailed.dart';
import 'package:taskflow_mobile/models/project/project_light.dart';
import 'package:taskflow_mobile/models/task/task_detailed.dart';
import 'package:taskflow_mobile/models/task/task_light.dart';
import 'package:taskflow_mobile/models/user/user.dart';
import 'package:taskflow_mobile/providers/services/project_service_provider.dart';
import 'package:taskflow_mobile/providers/tasks_list_provider.dart';
import 'package:taskflow_mobile/providers/users_provider.dart';
// Services
import 'package:taskflow_mobile/services/api/data/task_service.dart';
// Utils
import 'package:taskflow_mobile/utils/format_date.dart';
import 'package:taskflow_mobile/utils/snackbar_global.dart';
// Views
import 'package:taskflow_mobile/views/project_detail.dart';
import 'package:taskflow_mobile/views/projects_list.dart';
import 'package:taskflow_mobile/views/task_detail.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';
import 'package:taskflow_mobile/widgets/custom_elevated_button.dart';
import 'package:taskflow_mobile/widgets/skeleton/line_skeleton.dart';

class TaskForm extends ConsumerStatefulWidget {
  final ProjectDetailed? project;
  final TaskDetailed? task;
  const TaskForm({super.key, this.project, this.task});

  @override
  ConsumerState<TaskForm> createState() => TaskFormState();
}

class TaskFormState extends ConsumerState<TaskForm> {
  LoadState projectsState = LoadState.loading;
  List<ProjectLight> projects = [];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dueAtController;
  DateTime? _dueAtSelected;
  TaskPriority? _prioritySelected;
  ProjectLight? _projectSelected;
  List<User> allUsers = [];
  List<User> userOptions = [];
  User? _userSelected;

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    if (widget.task?.dueAt != null) {
      _dueAtController = TextEditingController(
        text: formatDateFr(widget.task!.dueAt),
      );
      _dueAtSelected = DateTime.parse(widget.task!.dueAt);
    } else {
      _dueAtController = TextEditingController();
    }
    if (widget.task?.priority != null) {
      _prioritySelected = TaskPriority.values.firstWhere(
        (priority) => priority.value == widget.task?.priority,
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueAtController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    final usersAsync = await ref.read(usersProvider.future);
    setState(() {
      allUsers = usersAsync.map(User.fromDetailed).toList();
    });
    await fetchProjects();
  }

  Future<void> fetchProjects() async {
    final projectService = ref.read(projectServiceProvider);
    try {
      final dataProjects = await projectService.getProjects(
        pagination: false,
        getAlsoArchived: false,
        sort: '-createdAt',
      );
      if (widget.project?.id != null) {
        ProjectLight projectSelected = dataProjects.data.firstWhere(
          (project) => project.id == widget.project!.id,
        );
        setState(() {
          _projectSelected = projectSelected;
          userOptions = allUsers
              .where((user) => projectSelected.members.contains(user.id))
              .toList();
        });
      }
      if (widget.task?.project.id != null) {
        ProjectLight projectSelected = dataProjects.data.firstWhere(
          (project) => project.id == widget.task!.project.id,
        );
        setState(() {
          _projectSelected = projectSelected;
          userOptions = allUsers
              .where((user) => projectSelected.members.contains(user.id))
              .toList();
          _userSelected = userOptions.firstWhere(
            (user) => user.id == widget.task?.assignee.id,
          );
        });
      }
      setState(() {
        projects = dataProjects.data;
        projectsState = LoadState.success;
      });
    } catch (e) {
      setState(() {
        projectsState = LoadState.error;
      });
    }
  }

  Future<void> _onValidationPressed() async {
    setState(() {
      _isProcessing = true;
    });
    try {
      final taskService = TaskService();
      // Update existing task
      if (widget.task?.id != null) {
        final task = await taskService.updateTask(
          id: widget.task!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          dueAt: formatDateTimeToStringApi(_dueAtSelected)!,
          priority: _prioritySelected!.value,
          assignee: _userSelected!.id,
        );
        if (!mounted) return;
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) =>
              TaskDetail(taskLight: TaskLight.fromDetailed(task)),
        );
        Navigator.of(context).pushReplacement(route);
        SnackbarGlobal.showSuccess('Tâche "${task.title}" modifié avec succès');
      }
      // Create new task
      else {
        final task = await taskService.createTask(
          title: _titleController.text,
          description: _descriptionController.text,
          dueAt: formatDateTimeToStringApi(_dueAtSelected)!,
          priority: _prioritySelected!.value,
          project: _projectSelected!.id,
          assignee: _userSelected!.id,
        );
        if (!mounted) return;
        if (widget.project != null) {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => ProjectDetail(
              projectLight: ProjectLight.fromDetailed(widget.project!),
            ),
          );
          Navigator.of(context).pushReplacement(route);
        } else if (_projectSelected != null) {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) =>
                ProjectDetail(projectLight: _projectSelected!),
          );
          Navigator.of(context).pushReplacement(route);
        } else {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => const ProjectsList(),
          );
          Navigator.of(context).pushReplacement(route);
        }
        ref.read(tasksListProvider.notifier).refresh();
        SnackbarGlobal.showSuccess('Projet "${task.title}" créé avec succès');
      }
    } catch (e) {
      if (!mounted) return;
      SnackbarGlobal.showError(
        'Erreur lors de la ${widget.task?.id != null ? 'modification' : 'création'} de la tâche',
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCurrentView(
        title: widget.task?.id != null
            ? 'Modification d\'une tâche'
            : 'Création d\'une tâche',
      ),
      bottomNavigationBar: BottomAppBarMenu(currentView: 'task'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // ------------------------ TITLE
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 30),
                        child: TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: "Titre"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le titre de la tâche est obligatoire';
                            }
                            return null;
                          },
                        ),
                      ),
                      // ------------------------  DESCRIPTION
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 30),
                        child: TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: "Description",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La description de la tâche est obligatoire';
                            }
                            return null;
                          },
                        ),
                      ),
                      // ------------------------ DUE AT
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 30),
                        child: TextFormField(
                          controller: _dueAtController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Échéance',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            final pickedDate = await pickDate(
                              context: context,
                              initialDate: _dueAtSelected,
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _dueAtSelected = pickedDate;
                                _dueAtController.text = formatDateTimeToString(
                                  pickedDate,
                                );
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La date d\'échéance est obligatoire';
                            }
                            return null;
                          },
                        ),
                      ),
                      // ------------------------ PRIORITY
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 30),
                        child: DropdownButtonFormField<TaskPriority>(
                          initialValue: _prioritySelected,
                          items: TaskPriority.values.map((priority) {
                            return DropdownMenuItem<TaskPriority>(
                              value: priority,
                              child: Text(priority.label),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _prioritySelected = value;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Priorité',
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'La priorité est obligatoire';
                            }
                            return null;
                          },
                        ),
                      ),
                      // ------------------------ PROJECT
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 30),
                        child: projectsState == LoadState.loading
                            ? LineSkeleton(context: context)
                            : projectsState == LoadState.error
                            ? Text(
                                'Erreur lors du chargement des donnés',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              )
                            : DropdownButtonFormField<ProjectLight>(
                                initialValue: _projectSelected,
                                items: projects.map((project) {
                                  return DropdownMenuItem<ProjectLight>(
                                    value: project,
                                    child: Text(project.title),
                                  );
                                }).toList(),
                                onChanged:
                                    (widget.project != null ||
                                        widget.task != null)
                                    ? null
                                    : (value) {
                                        setState(() {
                                          _projectSelected = value;
                                          if (value != null) {
                                            userOptions = allUsers
                                                .where(
                                                  (user) => value.members
                                                      .contains(user.id),
                                                )
                                                .toList();
                                            if (_userSelected != null &&
                                                !allUsers
                                                    .where(
                                                      (user) => value.members
                                                          .contains(user.id),
                                                    )
                                                    .toList()
                                                    .contains(_userSelected)) {
                                              _userSelected = null;
                                            }
                                          }
                                        });
                                      },
                                decoration: const InputDecoration(
                                  labelText: 'Projet',
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Le projet est obligatoire';
                                  }
                                  return null;
                                },
                              ),
                      ),

                      // ------------------------ ASSIGNEE
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 30),
                        child: projectsState == LoadState.loading
                            ? LineSkeleton(context: context)
                            : projectsState == LoadState.error
                            ? Text(
                                'Erreur lors du chargement des donnés',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              )
                            : DropdownButtonFormField<User>(
                                initialValue: _userSelected,
                                items: userOptions.map((user) {
                                  return DropdownMenuItem<User>(
                                    value: user,
                                    child: Text(
                                      '${user.firstname} ${user.lastname}',
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _userSelected = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Personne assignée',
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'La personne assignée est obligatoire';
                                  }
                                  return null;
                                },
                              ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _onValidationPressed();
                              }
                            },
                            child: _isProcessing
                                ? CircularProgressIndicator()
                                : Text(
                                    'Valider',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
