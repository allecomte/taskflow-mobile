import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Enums
import 'package:taskflow_mobile/enums/load_state.dart';
import 'package:taskflow_mobile/enums/priority.dart';
// Models
import 'package:taskflow_mobile/models/project/project_detailed.dart';
import 'package:taskflow_mobile/models/project/project_light.dart';
import 'package:taskflow_mobile/models/task/task_detailed.dart';
import 'package:taskflow_mobile/models/user/user.dart';
import 'package:taskflow_mobile/models/user/user_detailed.dart';
import 'package:taskflow_mobile/providers/users_provider.dart';
import 'package:taskflow_mobile/services/api/data/project_service.dart';
import 'package:taskflow_mobile/services/api/data/task_service.dart';
import 'package:taskflow_mobile/utils/format_date.dart';
import 'package:taskflow_mobile/utils/snackbar_info.dart';
import 'package:taskflow_mobile/views/project_detail.dart';
import 'package:taskflow_mobile/views/projects_list.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';

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
  Priority? _prioritySelected;
  ProjectLight? _projectSelected;
  User? _userSelected;

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    fetchProjects();
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
      _prioritySelected = Priority.values.firstWhere(
        (priority) => priority.value == widget.task?.priority,
      );
    }
    if (widget.task?.assignee != null) {
      _userSelected = widget.task?.assignee;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueAtController.dispose();
    super.dispose();
  }

  Future<void> fetchProjects() async {
    final projectService = ProjectService();
    try {
      final dataProjects = await projectService.getProjects(
        pagination: false,
        getAlsoArchived: false,
        sort: '-createdAt',
      );
      if (widget.project?.id != null) {
        setState(() {
          _projectSelected = dataProjects.data.firstWhere(
            (project) => project.id == widget.project!.id,
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
      if (widget.task?.id != null) {
        final task = await taskService.updateTask(
          id: widget.task!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          dueAt: formatDateTimeToStringApi(_dueAtSelected)!,
          priority: _prioritySelected!.value,
          assignee: _userSelected!.id,
        );
        //TODO redirect to task detailed
      } else {
        final task = await taskService.createTask(
          title: _titleController.text,
          description: _descriptionController.text,
          dueAt: formatDateTimeToStringApi(_dueAtSelected)!,
          priority: _prioritySelected!.value,
          project: _projectSelected!.id,
          assignee: _userSelected!.id,
        );
        if (widget.project != null) {
          if (!mounted) return;
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => ProjectDetail(
              projectLight: ProjectLight.fromDetailed(widget.project!),
            ),
          );
          Navigator.of(context).pushReplacement(route);
        }else{
          if (!mounted) return;
          MaterialPageRoute route = MaterialPageRoute(builder: (context) => const ProjectsList());
          Navigator.of(context).pushReplacement(route);
        }
      }
    } catch (e) {
      if (!mounted) return;
      SnackbarInfo.showError(
        context,
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
    final List<User> users;
    if (widget.project?.members != null) {
      users = widget.project!.members;
    } else {
      //TO DO filter _projectSelected.members
      final usersAsync = ref.watch(usersProvider);
      users = usersAsync.when(
        data: (usersDetailed) => usersDetailed.map(User.fromDetailed).toList(),
        loading: () => <User>[],
        error: (_, _) => <User>[],
      );
    }
    return Scaffold(
      appBar: AppBarCurrentView(title: 'Création d\'une tâche'),
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
                        child: DropdownButtonFormField<Priority>(
                          items: Priority.values.map((priority) {
                            return DropdownMenuItem<Priority>(
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
                        child: DropdownButtonFormField<ProjectLight>(
                          initialValue: _projectSelected,
                          items: projects.map((project) {
                            return DropdownMenuItem<ProjectLight>(
                              value: project,
                              child: Text(project.title),
                            );
                          }).toList(),
                          onChanged: widget.project != null
                              ? null
                              : (value) {
                                  setState(() {
                                    _projectSelected = value;
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
                        child: DropdownButtonFormField<User>(
                          items: users.map((user) {
                            return DropdownMenuItem<User>(
                              value: user,
                              child: Text('${user.firstname} ${user.lastname}'),
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
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _onValidationPressed();
                              }
                            },
                            child: _isProcessing
                                ? CircularProgressIndicator()
                                : Text('Valider'),
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
