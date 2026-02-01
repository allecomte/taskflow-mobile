import 'package:flutter/material.dart';
import 'package:taskflow_mobile/providers/auth_provider.dart';
import 'package:taskflow_mobile/providers/theme_mode_provider.dart';
import 'package:taskflow_mobile/theme/app_theme.dart';
import 'package:taskflow_mobile/views/home.dart';
import 'package:taskflow_mobile/views/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/views/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(child: MyApp())
    );
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On regarde l'état du provider d'auth
    final authState = ref.watch(authProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      navigatorObservers: [routeObserver],
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
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