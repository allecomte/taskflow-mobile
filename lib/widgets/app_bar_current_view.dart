import 'package:flutter/material.dart';

class AppBarCurrentView extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  const AppBarCurrentView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}