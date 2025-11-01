import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';
import 'package:flutter_exercise1_todolist/presentation/widgets/tasks/task_item.dart';
import 'package:flutter_svg/svg.dart';

/// Reusable list view widget for displaying tasks
class TaskListView extends StatelessWidget {
  final List<TaskEntity> tasks;
  final Map<int, bool> completedTasks;
  final Function(int, bool?) onTaskToggle;
  final Function(int) onTaskClicked;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.completedTasks,
    required this.onTaskToggle,
    required this.onTaskClicked,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskItem(
          task: task,
          isCompleted: completedTasks[task.id] ?? task.isCompleted,
          onChanged: (value) => onTaskToggle(task.id, value),
          onTaskClicked: onTaskClicked,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/ic_calendar.svg',
            width: 80,
            height: 80,
          ),
          SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
