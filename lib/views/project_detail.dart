import 'package:flutter/material.dart';
import 'package:taskflow_mobile/models/project/project_detailed.dart';
import 'package:taskflow_mobile/models/project/project_light.dart';
import 'package:taskflow_mobile/services/api/data/project_service.dart';
import 'package:taskflow_mobile/views/home.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';

class ProjectDetail extends StatefulWidget {
  final ProjectLight projectLight;
  const ProjectDetail({super.key, required this.projectLight});

  @override
  State<StatefulWidget> createState() => ProjectDetailState();
}

class ProjectDetailState extends State<ProjectDetail>{
  LoadState projectState = LoadState.loading;
  ProjectDetailed? projectDetail;

  @override
  void initState() {
    super.initState();
    fetchProject();
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
              children: [
                Text(widget.projectLight.description, style: TextStyle(color: Theme.of(context).colorScheme.primary),)
              ]
            )
            )
        ),
      ),
    );
  }
  Future<void>fetchProject() async {
    final projectService = ProjectService();
    
    try{

    } catch (e) {
        setState(() {
          projectState = LoadState.error;
        });
      }
  }
}