import 'package:flutter/material.dart';
import 'task_submit_button.dart';

class TaskSubmitSection extends StatelessWidget {
  final ColorScheme colorScheme;
  final VoidCallback? onSubmit;

  const TaskSubmitSection({
    super.key,
    required this.colorScheme,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TaskSubmitButton(colorScheme: colorScheme, onPressed: onSubmit),
      ],
    );
  }
}
