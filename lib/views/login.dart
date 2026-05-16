import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/providers/auth_provider.dart';
import 'package:taskflow_mobile/views/home.dart';
import 'package:taskflow_mobile/views/sign_up.dart';
import 'package:taskflow_mobile/widgets/custom_elevated_button.dart';
import 'package:taskflow_mobile/widgets/form/email_field.dart';
import 'package:taskflow_mobile/widgets/form/password_field.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => LoginState();
}

class LoginState extends ConsumerState<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _hasSubmitted = false;

  @override
  void initState() {
    super.initState();
  }

  void _login() {
    setState(() => _hasSubmitted = true);
    ref
        .read(authProvider.notifier)
        .login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  void _showForgotPasswordSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Icon(
            Icons.lock_reset,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Mot de passe oublié ?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Pour réinitialiser votre mot de passe, veuillez contacter l\'administrateur de l\'application.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Compris'),
            ),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (previous?.value == null && next is AsyncData && next.value != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Home()),
        );
      }
    });
    final authState = ref.watch(authProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                        child: EmailField(emailController: _emailController),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(top: 30),
                        child: PasswordField(
                          passwordController: _passwordController,
                          label: "Mot de passe",
                        ),
                      ),
                    ],
                  ),
                ),
                if (_hasSubmitted && authState.hasError)
                  Padding(
                    padding: EdgeInsetsGeometry.only(top: 30),
                    child: Text(
                      authState.error.toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Padding(
                  padding: EdgeInsetsGeometry.only(top: 30),
                  child: CustomElevatedButton(
                    onPressed: () {
                      if (authState.isLoading) {
                        null;
                      } else if (_formKey.currentState!.validate()) {
                        _login();
                      }
                    },
                    child: authState.isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            "Se connecter",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(top: 30),
                  child: InkWell(
                    onTap: () => _showForgotPasswordSheet(context),
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
      ),
    );
  }
}
