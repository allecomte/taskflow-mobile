import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/providers/auth_provider.dart';
import 'package:taskflow_mobile/views/home.dart';
import 'package:taskflow_mobile/views/sign_up.dart';
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
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void _login() {
    ref
        .read(authProvider.notifier)
        .login(
          email: _emailController.text,
          password: _passwordController.text,
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
                    onPressed: (){
                      if(authState.isLoading){
                        null;
                      }else if(_formKey.currentState!.validate()){
                        _login();
                      }
                    },
                    // onPressed: authState.isLoading ? null : _formKey.currentState!.validate() ? _login : null,
                    child: authState.isLoading
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
      ),
    );
  }
}
