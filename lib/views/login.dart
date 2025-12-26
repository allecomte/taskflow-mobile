import 'package:flutter/material.dart';
import 'package:taskflow_mobile/services/api/api_exception.dart';
import 'package:taskflow_mobile/services/api/auth_api.dart';
import 'package:taskflow_mobile/services/storage/secure_storage.dart';
import 'package:taskflow_mobile/views/home.dart';
import 'package:taskflow_mobile/views/sign_up.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final _authApi = AuthApi();

  bool _isLoading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = await _authApi.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await SecureStorage.saveToken(token);
      if (!mounted) return;
      // using pushReplacement prevent from going back
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      setState(() => _isLoading = false);
    }
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
              Padding(
                padding: EdgeInsetsGeometry.only(top: 50),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Adresse mail"),
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
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
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
                    return null;
                  },
                ),
              ),
              if (_error != null)
                Padding(
                  padding: EdgeInsetsGeometry.only(top: 30),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Padding(
                padding: EdgeInsetsGeometry.only(top: 30),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          "Se connecter",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.only(top: 30),
                child: InkWell(
                  onTap: () => {},
                  child: Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.only(top: 20),
                child: InkWell(
                  onTap: () => {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUp()),
                    ),
                  },
                  child: Text(
                    "Pas encore compte ? S'inscrire",
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
    );
  }
}
