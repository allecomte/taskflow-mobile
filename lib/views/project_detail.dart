import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/models/project/project_detailed.dart';
import 'package:taskflow_mobile/models/project/project_light.dart';
import 'package:taskflow_mobile/models/tag/tag.dart';
import 'package:taskflow_mobile/models/task/task_light.dart';
import 'package:taskflow_mobile/models/user/user.dart';
import 'package:taskflow_mobile/models/user/user_detailed.dart';
import 'package:taskflow_mobile/services/api/data/project_service.dart';
import 'package:taskflow_mobile/services/api/data/tag_service.dart';
import 'package:taskflow_mobile/utils/format_date.dart';
import 'package:taskflow_mobile/utils/snackbar_info.dart';
import 'package:taskflow_mobile/views/home.dart';
import 'package:taskflow_mobile/views/project_form_update.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';
import 'package:taskflow_mobile/widgets/bottom_sheet/add_tag_bottom_sheet.dart';
import 'package:taskflow_mobile/widgets/bottom_sheet/add_user_bottom_sheet.dart';
import 'package:taskflow_mobile/widgets/bottom_sheet/delete_tag_bottom_sheet.dart';
import 'package:taskflow_mobile/widgets/bottom_sheet/update_tag_bottom_sheet.dart';
import 'package:taskflow_mobile/widgets/card_task.dart';
import 'package:taskflow_mobile/widgets/chip_tag.dart';
import 'package:taskflow_mobile/widgets/item_member.dart';
import 'package:taskflow_mobile/widgets/skeleton/avatar_skeleton.dart';
import 'package:taskflow_mobile/widgets/skeleton/list_skeleton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';
import 'package:taskflow_mobile/widgets/skeleton/small_list_skeleton.dart';

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
  List<Tag> tags = [];
  List<User> members = [];

  @override
  void initState() {
    super.initState();
    fetchProject();
  }

  Future<void> refreshProject() async {
    await fetchProject();
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
        tags = project.tags;
        members = project.members;
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
      builder: (_) => const AddTagBottomSheet(),
    );

    if (tagName == null) return;

    _addTag(tagName);
  }

  Future<void> _addTag(String name) async {
    try {
      final tagService = TagService();
      final newTag = await tagService.createTag(
        projectId: widget.projectLight.id,
        name: name,
      );
      setState(() {
        tags.add(newTag);
      });
      if (!mounted) return;
      SnackbarInfo.showSuccess(context, 'Tag créé avec succès');
    } catch (e) {
      SnackbarInfo.showError(context, 'Erreur lors de la création du tag');
    }
  }

  Future<void> _onUpdateTagPressed(Tag tag) async {
    final newName = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => UpdateTagBottomSheet(initialName: tag.name),
    );

    if (newName == null || newName.isEmpty) return;

    _updateTag(tag, newName);
  }

  Future<void> _updateTag(Tag tag, String newName) async {
    try {
      final tagService = TagService();
      final updatedTag = await tagService.updateTag(
        tagId: tag.id,
        name: newName,
      );

      final index = tags.indexWhere((t) => t.id == tag.id);
      setState(() {
        tags[index] = updatedTag;
      });

      if (!mounted) return;
      SnackbarInfo.showSuccess(context, 'Tag modifié avec succès');
    } catch (e) {
      SnackbarInfo.showError(context, 'Erreur lors de la modification');
    }
  }

  Future<void> _onDeleteTagPressed(Tag tag) async {
    final confirm = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DeleteTagBottomSheet(tagName: tag.name),
    );

    if (confirm == true) {
      _deleteTag(tag);
    }
  }

  Future<void> _deleteTag(Tag tag) async {
    try {
      final tagService = TagService();
      await tagService.deleteTag(tagId: tag.id);

      setState(() {
        tags.removeWhere((t) => t.id == tag.id);
      });
      if (!mounted) return;
      SnackbarInfo.showSuccess(context, 'Tag supprimé');
    } catch (e) {
      SnackbarInfo.showError(context, 'Erreur lors de la suppression');
    }
  }

  Future<void> _onAddUserPressed() async {
    final UserDetailed? userToAdd = await showModalBottomSheet<UserDetailed>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const AddUserBottomSheet(userIdsToExclude: []),
    );
    if (userToAdd == null) return;
    __addMember(userToAdd);
  }

  Future<void> __addMember(UserDetailed user) async {
    try {
      final projectService = ProjectService();
      await projectService.addMemberToProject(
        projectId: widget.projectLight.id,
        userId: user.id,
      );
      setState(() {
        members.add(user);
      });
      if (!mounted) return;
      SnackbarInfo.showSuccess(context, '${user.firstname} ${user.lastname} a été au projet avec succès');
    } catch (e) {
      SnackbarInfo.showError(context, 'Erreur lors de l\'ajout de ${user.firstname} ${user.lastname} au projet');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final project = projectDetail ?? widget.projectLight;

    return Scaffold(
      appBar: AppBarCurrentView(
        title: project.title,
        actions: projectDetail != null && user!.roles.contains('ROLE_MANAGER')
            ? [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProjectFormUpdate(project: projectDetail!),
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
          onRefresh: refreshProject,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.description,
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
                      project.endAt!.isNotEmpty
                          ? Text(
                              "Du ${formatDateFr(project.startAt)} au ${formatDateFr(project.endAt!)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          : Text(
                              "À partir du ${formatDateFr(project.startAt)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // ------------------------------- MEMBERS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Membres',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                     if (user!.roles.contains('ROLE_MANAGER')) InkWell(onTap: _onAddUserPressed, child: Icon(FontAwesomeIcons.circlePlus, color: Theme.of(context).colorScheme.primary,),) 
                    ],
                  ),
                  SizedBox(height: 10),
                  projectState == LoadState.loading
                      ? AvatarSkeleton()
                      : projectState == LoadState.error
                      ? Text(
                          'Erreur lors du chargement des membres',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                      : members.isEmpty
                      ? Text(
                          "Aucune personne n'est associé au projet.",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      : SizedBox(
                          height: 90,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: members.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final member = members[index];
                              return ItemMember(
                                firstName: member.firstname,
                                lastName: member.lastname,
                              );
                            },
                          ),
                        ),
                  SizedBox(height: 20),
                  // ------------------------------- TAGS
                  Text(
                    'Tags',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  projectState == LoadState.loading
                      ? SmallListSkeleton()
                      : projectState == LoadState.error
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
                              onEdit: _onUpdateTagPressed,
                              onDelete: _onDeleteTagPressed,
                            );
                          }).toList(),
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
                            color: Theme.of(context).colorScheme.secondary,
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
      ),
    );
  }
}
