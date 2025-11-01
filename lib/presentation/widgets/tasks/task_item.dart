import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/core/enums/day_category.dart';
import 'package:flutter_exercise1_todolist/core/utils/task_filters.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';

/// Widget representing a single task item in the list
class TaskItem extends StatefulWidget {
  final TaskEntity task;
  final bool isCompleted;
  final Function(bool?) onChanged;
  final Function(int) onTaskClicked;

  const TaskItem({
    super.key,
    required this.task,
    required this.isCompleted,
    required this.onChanged,
    required this.onTaskClicked,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: colorScheme.primary.withAlpha(20)),
        color: colorScheme.primaryContainer.withAlpha(10),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        children: [
          _buildCheckbox(),
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onTaskClicked(widget.task.id),
              child: _buildTaskContent(colorScheme),
            ),
          ),
          if (widget.task.priorityType != null && !widget.task.isCompleted)
            _buildPriorityIcon(),
        ],
      ),
    );
  }

  Widget _buildCheckbox() {
    return Checkbox(value: widget.isCompleted, onChanged: widget.onChanged);
  }

  Widget _buildTaskContent(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(colorScheme),
        _buildDescription(colorScheme),
        _buildDueDate(),
      ],
    );
  }

  Widget _buildTitle(ColorScheme colorScheme) {
    return Text(
      widget.task.title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        decoration: widget.isCompleted ? TextDecoration.lineThrough : null,
        color: widget.isCompleted ? colorScheme.onSurfaceVariant : null,
      ),
    );
  }

  Widget _buildDescription(ColorScheme colorScheme) {
    return Text(
      widget.task.description,
      style: TextStyle(
        fontSize: 14,
        color: colorScheme.onSurfaceVariant.withAlpha(150),
        decoration: widget.isCompleted ? TextDecoration.lineThrough : null,
      ),
    );
  }

  Widget _buildDueDate() {
    if (widget.task.dueDate == null) {
      return const SizedBox.shrink();
    }

    // If completed, always show completed label
    if (widget.task.isCompleted) {
      return Column(
        children: [
          const SizedBox(height: 8),
          _buildDayLabel(DayCategory.completed),
        ],
      );
    }

    final dueDate = widget.task.dueDate!;

    // Check for today
    if (TaskFilters.isSameDay(dueDate, DayCategory.today.date)) {
      return Column(
        children: [
          const SizedBox(height: 8),
          _buildDayLabel(DayCategory.today),
        ],
      );
    }

    // Check for tomorrow
    if (TaskFilters.isSameDay(dueDate, DayCategory.tomorrow.date)) {
      return Column(
        children: [
          const SizedBox(height: 8),
          _buildDayLabel(DayCategory.tomorrow),
        ],
      );
    }

    // Other dates
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          'Due: ${dueDate.toLocal().toString().split(' ')[0]}',
          style: const TextStyle(fontSize: 12, color: Colors.purple),
        ),
      ],
    );
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
    return Icon(Icons.bookmark, color: widget.task.priorityType?.color.withAlpha(200));
  }
}
