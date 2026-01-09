import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/models/project/project_detailed.dart';
import 'package:taskflow_mobile/models/project/project_light.dart';
import 'package:taskflow_mobile/models/task/task_light.dart';
import 'package:taskflow_mobile/services/api/data/project_service.dart';
import 'package:taskflow_mobile/services/api/data/tag_service.dart';
import 'package:taskflow_mobile/utils/format_date.dart';
import 'package:taskflow_mobile/utils/snackbar_info.dart';
import 'package:taskflow_mobile/views/home.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';
import 'package:taskflow_mobile/widgets/bottom_sheet_add_tag.dart';
import 'package:taskflow_mobile/widgets/card_task.dart';
import 'package:taskflow_mobile/widgets/list_skeleton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';

class ProjectDetail extends ConsumerStatefulWidget {
  final ProjectLight projectLight;
  const ProjectDetail({super.key, required this.projectLight});

  @override
  ConsumerState<ProjectDetail> createState() => ProjectDetailState();
}

class ProjectDetailState extends ConsumerState<ProjectDetail> {
  LoadState projectState = LoadState.loading;
  ProjectDetailed? projectDetail;
  List<TaskLight> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchProject();
  }

  Future<void> fetchProject() async {
    final projectService = ProjectService();
    final user = ref.read(userProvider);
    try {
      final project = await projectService.getProjectById(
        widget.projectLight.id,
      );

      setState(() {
        projectDetail = project;
        tasks = project.tasks
            .where((task) => task.assigneeId == user?.id)
            .toList();
        projectState = LoadState.success;
      });
    } catch (e) {
      setState(() {
        projectState = LoadState.error;
      });
    }
  }

  Future<void> _onAddTagPressed() async {
    final tagName = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const BottomSheetAddTag(),
    );

    if (tagName == null) return;

    _addTag(tagName);
  }

  Future<void> _addTag(String name) async {
    try {
      final tagService = TagService();
      await tagService.createTag(
        projectId: widget.projectLight.id,
        name: name,
      );
      if (!mounted) return;
      SnackbarInfo.showSuccess(context, 'Tag créé avec succès');
    } catch (e) {
      if (!mounted) return;
      SnackbarInfo.showError(context, 'Erreur lors de la création du tag');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCurrentView(title: widget.projectLight.title),
      bottomNavigationBar: BottomAppBarMenu(currentView: 'project'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.projectLight.description,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.calendar,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 10),
                    widget.projectLight.endAt!.isNotEmpty
                        ? Text(
                            "Du ${formatDateFr(widget.projectLight.startAt)} au ${formatDateFr(widget.projectLight.endAt!)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : Text(
                            "À partir du ${formatDateFr(widget.projectLight.startAt)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Tags',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: _onAddTagPressed,
                  child: Chip(
                    label: Text(
                      'Ajouter un tag',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primaryFixed,
                    avatar: Icon(
                      FontAwesomeIcons.plus,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Mes tâches',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                projectState == LoadState.loading
                    ? ListSkeleton()
                    : projectState == LoadState.error
                    ? Text(
                        'Erreur lors du chargement des tâches',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    : tasks.isEmpty
                    ? Text(
                        "Le projet ne contient aucune tâche vous étant assignée.",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: ((context, index) =>
                            CardTask(task: projectDetail!.tasks[index])),
                        itemCount: projectDetail!.tasks.length,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
