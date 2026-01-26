import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController passwordController;
  final String label;

  const PasswordField({
    super.key,
    required this.passwordController,
    required this.label,
  });

  @override
  State<StatefulWidget> createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
    );
  }
}
