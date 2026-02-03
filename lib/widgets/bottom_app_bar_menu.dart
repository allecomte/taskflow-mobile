import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/views/home.dart';
import 'package:taskflow_mobile/views/profile.dart';
import 'package:taskflow_mobile/views/projects_list.dart';
import 'package:taskflow_mobile/views/tasks_list.dart';

class BottomAppBarMenu extends StatelessWidget {
  final String currentView;
  const BottomAppBarMenu({super.key, required this.currentView});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconSelected = isDark ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onPrimary;
    final iconUnselected = isDark ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.inversePrimary;
    return BottomAppBar(
      color: isDark ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary,
      surfaceTintColor: isDark ? Theme.of(context).colorScheme.primary.withAlpha(80) : null,
      elevation: isDark ? 2 : 0,
      child: Padding(
        padding: EdgeInsetsGeometry.directional(start: 16, end: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // -------- HOME BUTTON
            IconButton(
              onPressed: () {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => const Home(),
                );
                Navigator.of(context).push(route);
              },
              icon: Icon(
                FontAwesomeIcons.solidHouse,
                size: 35,
                color: currentView == 'home' ? iconSelected : iconUnselected,
              ),
            ),
            // -------- PROJECTS BUTTON
            IconButton(
              onPressed: () {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => const ProjectsList(),
                );
                Navigator.of(context).push(route);
              },
              icon: Icon(
                FontAwesomeIcons.solidFolder,
                size: 35,
                color: currentView == 'project'
                    ? iconSelected : iconUnselected,
              ),
            ),
            // -------- TASKS BUTTON
            IconButton(
              onPressed: () {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => const TasksList(),
                );
                Navigator.of(context).push(route);
              },
              icon: Icon(
                FontAwesomeIcons.list,
                size: 35,
                color: currentView == 'task'
                    ? iconSelected : iconUnselected,
              ),
            ),
            // -------- SEARCH BUTTON
            //TODO
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     FontAwesomeIcons.magnifyingGlass,
            //     size: 35,
            //     color: currentView == 'search'
            //         ? Theme.of(context).colorScheme.onPrimary
            //         : Theme.of(context).colorScheme.inversePrimary,
            //   ),
            // ),
            // -------- PROFILE BUTTON
            IconButton(
              onPressed: () {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => const Profile(),
                );
                Navigator.of(context).push(route);
              },
              icon: Icon(
                FontAwesomeIcons.user,
                size: 35,
                color: currentView == 'profile'
                    ? iconSelected : iconUnselected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
