import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/providers/auth_provider.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';
import 'package:taskflow_mobile/views/login.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}
class ProfileState extends ConsumerState<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBarCurrentView(title: 'Profile'),
      bottomNavigationBar: BottomAppBarMenu(currentView: 'profile'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: user == null ? 
          Text('Aucun utilisateur connecté') : 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${user.firstname} ${user.lastname}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Email: ${user.email}',
                style: TextStyle(fontSize: 18),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Supprimer token et user
                        await ref.read(authProvider.notifier).logout();
                        if (!context.mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const Login()),
                          (route) => false,
                        );
                  },
                  child: Text('Déconnexion'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}