import 'package:flutter/material.dart';
import 'package:taskflow_mobile/main.dart';

class SnackbarGlobal {
  static void showSuccess(String message) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      CustomSnackBar(message: message, backgroundColor: Colors.green) as SnackBar
    );
  }

  static void showError(String message) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      CustomSnackBar(message: message, backgroundColor: Colors.red) as SnackBar
    );
  }

  static void showInfo(String message) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      CustomSnackBar(message: message, backgroundColor: Colors.blueGrey) as SnackBar
    );
  }
}

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    super.key,
    required String message,
    required Color backgroundColor,
    int durationSeconds = 3,
  }) : super(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: Duration(seconds: durationSeconds),
        );
}