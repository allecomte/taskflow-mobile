import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController emailController;
  const EmailField({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      decoration: const InputDecoration(labelText: "Adresse mail"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'L’email est requis';
        }

        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

        if (!emailRegex.hasMatch(value)) {
          return 'Format d’email invalide';
        }
        return null;
      },
    );
  }
}
