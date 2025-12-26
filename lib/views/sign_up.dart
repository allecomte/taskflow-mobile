import 'package:flutter/material.dart';
import 'package:taskflow_mobile/views/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<StatefulWidget> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final _lastnameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _isLoading = false;
  String? _error;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                      padding: EdgeInsetsGeometry.only(top: 50),
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
                    ),Padding(
                      padding: EdgeInsetsGeometry.only(top: 30),
                      child: TextFormField(
                      controller: _firstnameController,
                      decoration: const InputDecoration(labelText: "Prénom"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le prénom est requis';
                        }
                        return null;
                      },
                    ),
                    ),Padding(
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
                    ),Padding(
                      padding: EdgeInsetsGeometry.only(top: 30),
                      child: TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      keyboardType: TextInputType.visiblePassword,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: "Mot de passe",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le mot de passe est requis';
                        }
                        if (value.length < 8) {
                          return 'Minimum 8 caractères';
                        }
                        return null;
                      },
                    ),
                    ),Padding(
                      padding: EdgeInsetsGeometry.only(top: 30),
                      child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      keyboardType: TextInputType.visiblePassword,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: "Confirmer le mot de passe",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La confirmation est requise';
                        }
                        if (value != _passwordController.text) {
                          return 'Les mots de passe renseignés doivent être identiques';
                        }
                        return null;
                      },
                    ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.only(top: 30),
                child: ElevatedButton(
                  onPressed: () {
                    if (_isLoading) {
                      return;
                    } else if (_formKey.currentState!.validate()) {
                      _signUp;
                    }
                  },
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          "S'inscrire",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.only(top: 20),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
