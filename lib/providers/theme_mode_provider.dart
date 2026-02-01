import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) {
    final notifier = ThemeModeNotifier();
    notifier.loadThemeMode();
    return notifier;
  },
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const _themeKey = 'theme_mode';

  ThemeModeNotifier() : super(ThemeMode.system);

  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_themeKey);

    if (value != null) {
      state = ThemeMode.values.firstWhere(
        (e) => e.name == value,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _themeKey,
      mode.name, 
    );
  }
}
