import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final String? label;
  final IconData? icon;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.iconSize = 16,
    this.padding,
  }) : assert(
         child != null || label != null,
         'Vous devez fournir soit child soit label',
       );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color foregroundColor(Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return colorScheme.onSurface.withAlpha(38);
      }
      return colorScheme.onPrimary;
    }

    Color backgroundColor(Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return colorScheme.onSurface.withAlpha(12);
      }
      return colorScheme.primary;
    }

    final textWidget =
        child ??
        Text(
          label!,
          style: TextStyle(
            color: onPressed == null
                ? colorScheme.onSurface.withAlpha(38)
                : colorScheme.onPrimary,
          ),
        );

    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(backgroundColor),
      foregroundColor: WidgetStateProperty.resolveWith(foregroundColor),
      padding: padding != null ? WidgetStateProperty.all(padding) : null,
    );

    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: iconSize,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        label: textWidget,
        style: style,
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: textWidget,
    );
  }
}
