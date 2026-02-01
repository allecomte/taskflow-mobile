import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/providers/auth_provider.dart';
import 'package:taskflow_mobile/providers/theme_mode_provider.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';
import 'package:taskflow_mobile/services/api/data/user_service.dart';
import 'package:taskflow_mobile/utils/snackbar_global.dart';
import 'package:taskflow_mobile/views/login.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';
import 'package:taskflow_mobile/widgets/card_theme_selector.dart';
import 'package:taskflow_mobile/widgets/form/email_field.dart';
import 'package:taskflow_mobile/widgets/form/password_field.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends ConsumerState<Profile> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isUpdateProfileProcessing = false;
  bool _isUpdatePasswordProcessing = false;
  final _updateProfileFormKey = GlobalKey<FormState>();
  final _updatePasswordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    if (user != null) {
      _firstnameController.text = user.firstname;
      _lastnameController.text = user.lastname;
      _emailController.text = user.email;
    }
  }

  Future<void> _onSubmitProfileUpdate() async {
    final firstname = _firstnameController.text;
    final lastname = _lastnameController.text;
    final email = _emailController.text;
    setState(() {
      _isUpdateProfileProcessing = true;
    });
    try {
      final userService = UserService();
      final updatedUser = await userService.updateUserProfile(
        firstname: firstname,
        lastname: lastname,
        email: email,
      );
      ref.read(userProvider.notifier).updateUser((currentUser) {
        return currentUser.copyWith(
          firstname: updatedUser.firstname,
          lastname: updatedUser.lastname,
          email: updatedUser.email,
        );
      });
      SnackbarGlobal.showSuccess('Informations mise à jour avec succès');
    } catch (e) {
      if (!mounted) return;
      SnackbarGlobal.showError(
        'Erreur lors de la mise à jour des informations du profil',
      );
    } finally {
      setState(() {
        _isUpdateProfileProcessing = false;
      });
    }
  }

  Future<void> _onSubmitPasswordController() async {
    final currentPassword = _passwordController.text;
    final newPassword = _newPasswordController.text;
    setState(() {
      _isUpdatePasswordProcessing = true;
    });
    try {
      final userService = UserService();
      await userService.updateUserPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      if (!mounted) return;
      SnackbarGlobal.showError(
        'Erreur lors de la mise à jour du mot de passe du profil',
      );
    } finally {
      setState(() {
        _isUpdatePasswordProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBarCurrentView(
        title: 'Mon profil',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async {
                // Supprimer token et user
                await ref.read(authProvider.notifier).logout();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                  (route) => false,
                );
              },
              icon: Icon(FontAwesomeIcons.arrowRightFromBracket),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBarMenu(currentView: 'profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: user == null
                  ? Text('Aucun utilisateur connecté')
                  : Column(
                      children: [
                        // Theme mode
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withAlpha(50),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Thème',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: CardThemeSelector(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        // Personal Information Section
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withAlpha(50),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mes informations personnelles',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 16),
                              Form(
                                key: _updateProfileFormKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _lastnameController,
                                      decoration: const InputDecoration(
                                        labelText: "Nom",
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Le nom de famille est requis';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    TextFormField(
                                      controller: _firstnameController,
                                      decoration: const InputDecoration(
                                        labelText: "Prénom",
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Le prénom est requis';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    EmailField(
                                      emailController: _emailController,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_isUpdateProfileProcessing) {
                                      return;
                                    } else if (_updateProfileFormKey
                                        .currentState!
                                        .validate()) {
                                      _onSubmitProfileUpdate();
                                    }
                                  },
                                  child: _isUpdateProfileProcessing
                                      ? CircularProgressIndicator()
                                      : Text("Valider"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        // Change Password Section
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withAlpha(50),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Changer le mot de passe',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 16),
                              Form(
                                key: _updatePasswordFormKey,
                                child: Column(
                                  children: [
                                    PasswordField(
                                      passwordController: _passwordController,
                                      label: 'Mot de passe actuel',
                                    ),
                                    SizedBox(height: 16),
                                    PasswordField(
                                      passwordController:
                                          _newPasswordController,
                                      label: 'Nouveau mot de passe',
                                      confirmController: _passwordController,
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 24),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_isUpdatePasswordProcessing) {
                                      return;
                                    } else if (_updatePasswordFormKey
                                        .currentState!
                                        .validate()) {
                                      _onSubmitPasswordController();
                                    }
                                  },
                                  child: _isUpdatePasswordProcessing
                                      ? CircularProgressIndicator()
                                      : Text("Valider"),
                                ),
                              ),
                            ],
                          ),
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
