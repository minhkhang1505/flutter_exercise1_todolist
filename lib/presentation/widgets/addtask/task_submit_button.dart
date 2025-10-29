import 'package:flutter/material.dart';

/// Circular submit button for the add task form
class TaskSubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final ColorScheme colorScheme;

  const TaskSubmitButton({
    super.key,
    required this.onPressed,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        disabledBackgroundColor: colorScheme.primary.withAlpha(100),
        shape: CircleBorder(
          side: BorderSide(color: colorScheme.primary.withAlpha(20), width: 2),
        ),
      ),
      label: Icon(
        Icons.arrow_upward,
        size: 24,
        color: isEnabled
            ? colorScheme.onPrimary
            : colorScheme.onPrimary.withAlpha(100),
      ),
    );
  }
}
