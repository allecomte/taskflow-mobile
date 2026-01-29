import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// Enums
import 'package:taskflow_mobile/enums/load_state.dart';
import 'package:taskflow_mobile/main.dart';
// Models
import 'package:taskflow_mobile/models/project/project_light.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';
import 'package:taskflow_mobile/services/api/data/project_service.dart';
import 'package:taskflow_mobile/views/project_form.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';
import 'package:taskflow_mobile/widgets/card_project.dart';
import 'package:taskflow_mobile/widgets/skeleton/list_skeleton.dart';

class ProjectsList extends ConsumerStatefulWidget {
  const ProjectsList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ProjectsListState();
}

class ProjectsListState extends ConsumerState<ProjectsList> with RouteAware {
  LoadState projectsState = LoadState.loading;
  List<ProjectLight> projects = [];

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // subscribe to route changes
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    // unsubscribe from route changes
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when the current route has been popped back to
    refreshProjects();
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
    final user = ref.watch(userProvider);
    final isUserManager = user!.roles.contains('ROLE_MANAGER');
    return Scaffold(
      appBar: AppBarCurrentView(
        title: 'Mes Projets',
        actions: isUserManager ? [
          Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProjectForm(),
                        ),
                      );
                    },
                    icon: Icon(
                      FontAwesomeIcons.circlePlus,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                )
        ] : [],
        ),
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
                  ? Center(child: Text(
                        "Vous n'avez aucun projet",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontStyle: FontStyle.italic,
                        ),
                      ),) 
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
