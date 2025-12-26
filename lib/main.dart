import 'package:flutter/material.dart';
import 'package:taskflow_mobile/views/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Color(0xFF1C845C)),
      ),
      home: const Login(),
    );
  }
}
