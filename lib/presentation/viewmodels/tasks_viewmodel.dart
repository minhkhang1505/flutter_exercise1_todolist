import 'package:flutter/cupertino.dart';
import 'package:flutter_exercise1_todolist/core/utils/task_filters.dart';
import 'package:flutter_exercise1_todolist/data/datasources/task_local_datasource.dart';
import 'package:flutter_exercise1_todolist/data/repositories/repository_implement.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';

/// Controller class to handle tasks business logic and data management
/// Separates business logic from UI for better maintainability
class TasksViewModel extends ChangeNotifier {
  //final TaskLocalDataSource _dataSource = TaskLocalDataSource();
final TaskRepositoryImpl _dataSource = TaskRepositoryImpl();


  List<TaskEntity> _tasks = [];
  final Map<int, bool> _completedTasks = {};

  /// Get all tasks
  List<TaskEntity> get allTasks => _tasks;

  /// Get today's tasks
  List<TaskEntity> get todayTasks => TaskFilters.getTodayTasks(_tasks);

  /// Get upcoming tasks
  List<TaskEntity> get upcomingTasks => TaskFilters.getUpcomingTasks(_tasks);

  /// Get completion status map
  Map<int, bool> get completedTasks => _completedTasks;

  /// Load tasks from data source
  Future<void> loadTasks() async {
    _tasks = await _dataSource.getTasks();
    notifyListeners();
  }

  /// Toggle task completion status
  void toggleTaskCompletion(int taskId, bool? value) {
    _completedTasks[taskId] = value ?? false;
  }

  /// Add a new task to the list
  void addTask(TaskEntity task) {
    _tasks.add(task);
    notifyListeners();
  }

  /// Clear all completed tasks
  void clearCompleted() {
    _tasks.removeWhere((task) => _completedTasks[task.id] ?? task.isCompleted);
    _completedTasks.clear();
    notifyListeners();
  }
}
