import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomAppBarMenu extends StatelessWidget {
  final String currentView;
  const BottomAppBarMenu({super.key, required this.currentView});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.solidHouse, size: 35, color: currentView == 'home' ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.inversePrimary)),
            IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.solidFolder, size: 35, color: currentView == 'project' ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.inversePrimary)),
            IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.list, size: 35, color: currentView == 'task' ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.inversePrimary)),
            IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.magnifyingGlass, size: 35, color: currentView == 'search' ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.inversePrimary)),
            IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.user, size: 35, color: currentView == 'profile' ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.inversePrimary)),
          ],
        ),
      ),
    );
  }
}