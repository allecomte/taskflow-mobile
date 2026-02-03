import 'package:flutter/material.dart';

const seedColor = Color(0xFF1C845C);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
    surface: Color(0xFF2B322E),
    secondary: Color(0xFF3E916D)
  ),
  scaffoldBackgroundColor: Color(0xFF161D19),
  useMaterial3: true,
);
