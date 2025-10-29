import 'package:flutter/material.dart';
import '../../../core/formatters/date_time_formatter.dart';
import '../../../core/formatters/priority_formatter.dart';
import 'task_action_button.dart';

class TaskActionSection extends StatelessWidget {
  final DateTime? dueDate;
  final TimeOfDay? dueTime;
  final String? priority;
  final VoidCallback onSelectDate;
  final VoidCallback onSelectTime;
  final VoidCallback onSelectPriority;

  const TaskActionSection({
    super.key,
    required this.dueDate,
    required this.dueTime,
    required this.priority,
    required this.onSelectDate,
    required this.onSelectTime,
    required this.onSelectPriority,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TaskActionButton(
            colorScheme: colorScheme,
            onPressed: onSelectDate,
            child: Row(
              children: [
                const Icon(Icons.calendar_month),
                const SizedBox(width: 8),
                Text(DateTimeFormatter.formatDate(dueDate)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TaskActionButton(
            colorScheme: colorScheme,
            onPressed: onSelectTime,
            child: Row(
              children: [
                const Icon(Icons.alarm),
                const SizedBox(width: 8),
                Text(DateTimeFormatter.formatTime(dueTime)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TaskActionButton(
            colorScheme: colorScheme,
            onPressed: onSelectPriority,
            child: PriorityFormatter.formatPriorityWidget(
              priority,
              colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
