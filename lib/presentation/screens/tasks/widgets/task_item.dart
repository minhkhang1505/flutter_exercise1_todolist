import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/core/enums/day_category.dart';
import 'package:flutter_exercise1_todolist/core/utils/task_filters.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';

/// Widget representing a single task item in the list
class TaskItem extends StatelessWidget {
  final Task task;
  final bool isCompleted;
  final Function(bool?) onChanged;

  const TaskItem({
    super.key,
    required this.task,
    required this.isCompleted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: colorScheme.primaryContainer),
        color: colorScheme.primaryContainer.withAlpha(50),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        children: [
          _buildCheckbox(),
          Expanded(child: _buildTaskContent(colorScheme)),
          if (task.priorityType != null) _buildPriorityIcon(),
        ],
      ),
    );
  }

  Widget _buildCheckbox() {
    return Checkbox(value: isCompleted, onChanged: onChanged);
  }

  Widget _buildTaskContent(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(colorScheme),
        _buildDescription(colorScheme),
        const SizedBox(height: 12),
        _buildDueDate(),
      ],
    );
  }

  Widget _buildTitle(ColorScheme colorScheme) {
    return Text(
      task.title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        decoration: isCompleted ? TextDecoration.lineThrough : null,
        color: isCompleted ? colorScheme.onSurfaceVariant : null,
      ),
    );
  }

  Widget _buildDescription(ColorScheme colorScheme) {
    return Text(
      task.description,
      style: TextStyle(
        fontSize: 14,
        color: colorScheme.onSurfaceVariant,
        decoration: isCompleted ? TextDecoration.lineThrough : null,
      ),
    );
  }

  Widget _buildDueDate() {
    if (TaskFilters.isSameDay(task.dueDate, DayCategory.today.date)) {
      return _buildDayLabel(DayCategory.today);
    } else if (TaskFilters.isSameDay(task.dueDate, DayCategory.tomorrow.date)) {
      return _buildDayLabel(DayCategory.tomorrow);
    } else {
      return Text(
        'Due: ${task.dueDate.toLocal().toString().split(' ')[0]}',
        style: const TextStyle(fontSize: 12, color: Colors.purple),
      );
    }
  }

  Widget _buildDayLabel(DayCategory category) {
    return Text(
      category.label,
      style: TextStyle(
        fontSize: 12,
        color: category.color,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildPriorityIcon() {
    return Icon(Icons.bookmark, color: task.priorityType?.color.withAlpha(200));
  }
}
