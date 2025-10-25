import 'package:flutter_exercise1_todolist/core/utils/task_filters.dart';
import 'package:flutter_exercise1_todolist/data/datasources/task_local_datasource.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';

/// Controller class to handle tasks business logic and data management
/// Separates business logic from UI for better maintainability
class TasksController {
  final TaskLocalDataSource _dataSource = TaskLocalDataSource();

  List<Task> _tasks = [];
  final Map<int, bool> _completedTasks = {};

  /// Get all tasks
  List<Task> get allTasks => _tasks;

  /// Get today's tasks
  List<Task> get todayTasks => TaskFilters.getTodayTasks(_tasks);

  /// Get upcoming tasks
  List<Task> get upcomingTasks => TaskFilters.getUpcomingTasks(_tasks);

  /// Get completion status map
  Map<int, bool> get completedTasks => _completedTasks;

  /// Load tasks from data source
  Future<void> loadTasks() async {
    _tasks = await _dataSource.getTasks();
  }

  /// Toggle task completion status
  void toggleTaskCompletion(int taskId, bool? value) {
    _completedTasks[taskId] = value ?? false;
  }

  /// Add a new task to the list
  void addTask(Task task) {
    _tasks.add(task);
  }

  /// Remove a task from the list
  void removeTask(int taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    _completedTasks.remove(taskId);
  }

  /// Update an existing task
  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
    }
  }

  /// Clear all completed tasks
  void clearCompleted() {
    _tasks.removeWhere((task) => _completedTasks[task.id] ?? task.isCompleted);
    _completedTasks.clear();
  }
}
