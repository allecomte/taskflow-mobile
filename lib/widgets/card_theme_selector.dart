import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/providers/theme_mode_provider.dart';
import 'package:taskflow_mobile/widgets/item_theme_option.dart';

class CardThemeSelector extends ConsumerWidget {
  const CardThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return IntrinsicHeight(
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ItemThemeOption(
              icon: Icons.phone_android,
              label: 'Par défaut',
              isSelected: themeMode == ThemeMode.system,
              colorScheme: colorScheme,
              onTap: () {
                ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(ThemeMode.system);
              },
            ),
            const SizedBox(width: 12),
            ItemThemeOption(
              icon: Icons.light_mode,
              label: 'Clair',
              isSelected: themeMode == ThemeMode.light,
              colorScheme: colorScheme,
              onTap: () {
                ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(ThemeMode.light);
              },
            ),
            const SizedBox(width: 12),
            ItemThemeOption(
              icon: Icons.dark_mode,
              label: 'Sombre',
              isSelected: themeMode == ThemeMode.dark,
              colorScheme: colorScheme,
              onTap: () {
                ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(ThemeMode.dark);
              },
            ),
          ],
        ),
    );

    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    // children: [
    //   ItemThemeOption(
    //     icon: Icons.phone_android,
    //     label: 'Par défaut',
    //     isSelected: themeMode == ThemeMode.system,
    //     colorScheme: colorScheme,
    //     onTap: () {
    //       ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system);
    //     },
    //   ),
    //   const SizedBox(width: 12),
    //   ItemThemeOption(
    //     icon: Icons.light_mode,
    //     label: 'Clair',
    //     isSelected: themeMode == ThemeMode.light,
    //     colorScheme: colorScheme,
    //     onTap: () {
    //       ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
    //     },
    //   ),
    //   const SizedBox(width: 12),
    //   ItemThemeOption(
    //     icon: Icons.dark_mode,
    //     label: 'Sombre',
    //     isSelected: themeMode == ThemeMode.dark,
    //     colorScheme: colorScheme,
    //     onTap: () {
    //       ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
    //     },
    //   ),
    // ],
    // );
  }
}
