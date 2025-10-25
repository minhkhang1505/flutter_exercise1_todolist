import 'package:flutter/material.dart';

/// Floating action button for adding new tasks
class TasksFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const TasksFloatingButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      onPressed: onPressed,
      tooltip: 'Add Task',
      child: const Icon(Icons.add),
    );
  }
}
