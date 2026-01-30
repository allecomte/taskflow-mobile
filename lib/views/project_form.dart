import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/models/project/project_detailed.dart';
import 'package:taskflow_mobile/models/project/project_light.dart';
import 'package:taskflow_mobile/providers/services/project_service_provider.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';
import 'package:taskflow_mobile/utils/snackbar_global.dart';
import 'package:taskflow_mobile/views/project_detail.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';
import 'package:taskflow_mobile/utils/format_date.dart';

class ProjectForm extends ConsumerStatefulWidget {
  final ProjectDetailed? project;

  const ProjectForm({super.key, this.project});

  @override
  ConsumerState<ProjectForm> createState() => ProjectFormUpdateState();
}

class ProjectFormUpdateState extends ConsumerState<ProjectForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _startAtController;
  DateTime? _startAtSelected;
  late final TextEditingController _endAtController;
  DateTime? _endAtSelected;

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.project?.description ?? '',
    );
    if (widget.project?.startAt != null) {
      _startAtController = TextEditingController(
        text: formatDateFr(widget.project!.startAt),
      );
      _startAtSelected = DateTime.parse(widget.project!.startAt);
    } else {
      _startAtController = TextEditingController();
    }

    if (widget.project?.endAt != null) {
      _endAtController = TextEditingController(
        text: formatDateFr(widget.project!.endAt!),
      );
      _endAtSelected = DateTime.parse(widget.project!.endAt!);
    } else {
      _endAtController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startAtController.dispose();
    _endAtController.dispose();
    super.dispose();
  }

  Future<void> _onValidationPressed() async {
    setState(() {
      _isProcessing = true;
    });
    try {
      final projectService = ref.read(projectServiceProvider);
      // Update existing project
      if (widget.project?.id != null) {
        final project = await projectService.updateProject(
          id: widget.project!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          startAt: formatDateTimeToStringApi(_startAtSelected)!,
          endAt: formatDateTimeToStringApi(_endAtSelected),
        );
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) =>
              ProjectDetail(projectLight: ProjectLight.fromDetailed(project)),
        );
        if (!mounted) return;
        Navigator.of(context)
          ..pop()
          ..pushReplacement(route);
          SnackbarGlobal.showSuccess(
          'Projet "${project.title}" modifié avec succès',
        );
      }
      // Create new project
      else {
        final project = await projectService.createProject(
          title: _titleController.text,
          description: _descriptionController.text,
          startAt: formatDateTimeToStringApi(_startAtSelected)!,
          endAt: formatDateTimeToStringApi(_endAtSelected),
        );
        ref.read(userProvider.notifier).updateUser((currentUser) {
          return currentUser.copyWith(
            projectsOwned: [...currentUser.projectsOwned, project.id],
          );
        });
        if (!mounted) return;
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ProjectDetail(projectLight: project),
        );
        Navigator.of(context).pushReplacement(route);
        SnackbarGlobal.showSuccess(
          'Projet "${project.title}" créé avec succès',
        );
      }
    } catch (e) {
      SnackbarGlobal.showError(
        'Erreur lors de la ${widget.project?.id != null ? 'modification' : 'création'} du projet',
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
        title: widget.project?.id != null
            ? 'Modification d\'un projet'
            : 'Création d\'une projet',
      ),
      bottomNavigationBar: BottomAppBarMenu(currentView: 'project'),
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
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 30),
                        child: TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: "Titre"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le titre du projet est obligatoire';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 30),
                        child: TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: "Description",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La description du projet est obligatoire';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 30),
                        child: TextFormField(
                          controller: _startAtController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Date de début',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            final pickedDate = await pickDate(
                              context: context,
                              initialDate: _startAtSelected,
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _startAtSelected = pickedDate;
                                _startAtController.text =
                                    formatDateTimeToString(pickedDate);
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La date de début est obligatoire';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 30),
                        child: TextFormField(
                          controller: _endAtController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Date de fin',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            final pickedDate = await pickDate(
                              context: context,
                              initialDate: _endAtSelected,
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _endAtSelected = pickedDate;
                                _endAtController.text = formatDateTimeToString(
                                  pickedDate,
                                );
                              });
                            }
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
