import 'package:flutter/material.dart';

/// Reusable styled button for date, time, and priority actions
class TaskActionButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;

  const TaskActionButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.primary.withAlpha(100), width: 1),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
