import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';
import 'package:flutter_exercise1_todolist/presentation/widgets/tasks/task_item.dart';

/// Reusable list view widget for displaying tasks
class TaskListView extends StatelessWidget {
  final List<Task> tasks;
  final Map<int, bool> completedTasks;
  final Function(int, bool?) onTaskToggle;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.completedTasks,
    required this.onTaskToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return _buildEmptyState();
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
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
