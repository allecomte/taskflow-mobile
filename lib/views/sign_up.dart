import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/providers/auth_provider.dart';
import 'package:taskflow_mobile/views/home.dart';
import 'package:taskflow_mobile/views/login.dart';
import 'package:taskflow_mobile/widgets/form/password_field.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => SignUpState();
}

class SignUpState extends ConsumerState<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final _lastnameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState(){
    super.initState();
  }

  void _signUp() {
    ref
        .read(authProvider.notifier)
        .register(
          firstname: _firstnameController.text,
          lastname: _lastnameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<String?>>(authProvider, (previous,next){
      next.whenOrNull(
        data: (token) {
          if(token != null){
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Home()),
          );
          }
        },
        error: (_,_){

        }
      );
    });
    final authState = ref.watch(authProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(50),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage("assets/images/logo.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.only(top: 30),
                          child: TextFormField(
                            controller: _lastnameController,
                            decoration: const InputDecoration(labelText: "Nom"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Le nom de famille est requis';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.only(top: 30),
                          child: TextFormField(
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
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.only(top: 30),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              labelText: "Adresse mail",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'L’email est requis';
                              }

                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );

                              if (!emailRegex.hasMatch(value)) {
                                return 'Format d’email invalide';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.only(top: 30),
                          child: PasswordField(
                            passwordController: _passwordController,
                            label: "Mot de passe",
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.only(top: 30),
                          child: PasswordField(
                            passwordController: _confirmPasswordController,
                            label: "Confirmer le mot de passe",
                            confirmController: _passwordController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (authState.hasError)
                    Padding(
                      padding: EdgeInsetsGeometry.only(top: 30),
                      child: Text(
                        authState.error.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsetsGeometry.only(top: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        if (authState.isLoading) {
                          null;
                        } else if (_formKey.currentState!.validate()) {
                          _signUp();
                        }
                      },
                      child: authState.isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              "S'inscrire",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.directional(
                      top: 20,
                      bottom: 20,
                    ),
                    child: InkWell(
                      onTap: () => {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const Login()),
                        ),
                      },
                      child: Text(
                        "Déjà un compte ? Se connecter",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
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
