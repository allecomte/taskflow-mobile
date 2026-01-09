import 'package:flutter/material.dart';
// Enums
import 'package:taskflow_mobile/enums/load_state.dart';
// Models
import 'package:taskflow_mobile/models/project/project_light.dart';
import 'package:taskflow_mobile/services/api/data/project_service.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';
import 'package:taskflow_mobile/widgets/card_project.dart';
import 'package:taskflow_mobile/widgets/skeleton/list_skeleton.dart';

class ProjectsList extends StatefulWidget {
  const ProjectsList({super.key});

  @override
  State<StatefulWidget> createState() => ProjectsListState();
}

class ProjectsListState extends State<ProjectsList> {
  LoadState projectsState = LoadState.loading;
  List<ProjectLight> projects = [];

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    final projectService = ProjectService();
    try {
      final dataProjects = await projectService.getProjects(
        pagination: false,
        getAlsoArchived: false,
        sort: '-createdAt',
      );
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

  Future<void> refreshProjects() async {
    setState(() {
      projectsState = LoadState.loading;
    });
    await fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCurrentView(title: 'Mes Projets'),
      bottomNavigationBar: BottomAppBarMenu(currentView: 'project'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshProjects,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: projectsState == LoadState.loading
                  ? ListSkeleton(itemCount: 10)
                  : projectsState == LoadState.error
                  ? Text(
                      'Erreur lors du chargement des projets',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
                  : projects.isEmpty
                  ? Text(
                      "Vous n'avez aucun projet",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) =>
                          CardProject(project: projects[index])),
                      itemCount: projects.length,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
