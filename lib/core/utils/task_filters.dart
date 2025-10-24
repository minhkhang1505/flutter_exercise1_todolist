import 'package:flutter_exercise1_todolist/domain/entities/task.dart';

/// Utility class for filtering tasks
class TaskFilters {
  /// Check if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Filter tasks that are due today
  static List<Task> getTodayTasks(List<Task> tasks) {
    final now = DateTime.now();
    return tasks
        .where((task) => task.dueDate != null && isSameDay(task.dueDate!, now))
        .toList();
  }

  /// Filter tasks that are due in the future (after today)
  static List<Task> getUpcomingTasks(List<Task> tasks) {
    final now = DateTime.now();
    return tasks
        .where((task) => task.dueDate != null && task.dueDate!.isAfter(now))
        .toList();
  }

  /// Filter completed tasks
  static List<Task> getCompletedTasks(
    List<Task> tasks,
    Map<int, bool> completionStatus,
  ) {
    return tasks
        .where((task) => completionStatus[task.id] ?? task.isCompleted)
        .toList();
  }

  /// Filter incomplete tasks
  static List<Task> getIncompleteTasks(
    List<Task> tasks,
    Map<int, bool> completionStatus,
  ) {
    return tasks
        .where((task) => !(completionStatus[task.id] ?? task.isCompleted))
        .toList();
  }

  /// Filter tasks by priority
  static List<Task> getTasksByPriority(
    List<Task> tasks,
    List<String> priorities,
  ) {
    return tasks
        .where(
          (task) =>
              task.priorityType != null &&
              priorities.contains(task.priorityType!.name),
        )
        .toList();
  }
}
