import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/data/datasources/task_local_datasource.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';
import 'package:flutter_exercise1_todolist/core/enums/priority_type.dart';
import '../models/add_task_form_data.dart';

class AddTaskViewmodel extends ChangeNotifier {
  final TaskLocalDataSource _dataSource = TaskLocalDataSource();

  List<TaskEntity> _tasks = [];

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Add a new task
  Future<bool> addNewTask(AddTaskFormData formData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Convert form data to TaskEntity
      final taskEntity = _convertFormDataToEntity(formData);

      // Add task through data source
      await _dataSource.addTask(taskEntity);

      _tasks = await _dataSource.getTasks();

      for (var task in _tasks) {
        debugPrint("📝 Task: ${task.id} - ${task.title}");
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Convert AddTaskFormData to TaskEntity
  TaskEntity _convertFormDataToEntity(AddTaskFormData formData) {
    // Generate unique ID (using timestamp for simplicity)
    final id = DateTime.now().millisecondsSinceEpoch;

    // Convert priority string to enum
    PriorityType? priorityType;
    if (formData.priority != null) {
      priorityType = PriorityType.values.firstWhere(
        (type) => type.name == formData.priority,
        orElse: () => PriorityType.low,
      );
    }

    return TaskEntity(
      id: id,
      title: formData.title,
      description: formData.description,
      dueDate: formData.dueDate,
      startDate: DateTime.now(), // Set start date to now
      deadline: formData.dueTime, // Use dueTime as deadline
      isCompleted: false,
      priorityType: priorityType,
    );
  }

  /// Clear any error state
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
