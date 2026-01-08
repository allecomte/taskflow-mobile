import 'package:flutter/material.dart';
import 'package:taskflow_mobile/providers/auth_provider.dart';
import 'package:taskflow_mobile/views/home.dart';
import 'package:taskflow_mobile/views/login_consumer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/views/splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp())
    );
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'TaskFlow',
//       theme: ThemeData(
//         colorScheme: .fromSeed(seedColor: Color(0xFF1C845C)),
//       ),
//       home: const Login(),
//     );
//   }
// }

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On regarde l'état du provider d'auth
    final authState = ref.watch(authProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1C845C)),
      ),
      home: authState.when(
        data: (token) {
          if (token != null && token.isNotEmpty) {
            return const Home();
          } else {
            return const Login();
          }
        },
        loading: () => const SplashScreen(),
        error: (_, _) => const Login(),
      ),
    );
  }
}