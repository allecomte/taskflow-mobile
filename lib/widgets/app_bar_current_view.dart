import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarCurrentView extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  const AppBarCurrentView({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          FontAwesomeIcons.chevronLeft,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      centerTitle: false,
      titleSpacing: 0,
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      actions: actions
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
