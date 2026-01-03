import 'package:flutter/material.dart';

class ProjectDetail extends StatefulWidget {
  const ProjectDetail({super.key});

  @override
  State<StatefulWidget> createState() => ProjectDetailState();
}

class ProjectDetailState extends State<ProjectDetail>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('Project Detail')
      ),
    );
  }

}