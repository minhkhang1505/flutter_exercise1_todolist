import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/data/datasources/task_local_datasource.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';
import 'package:flutter_exercise1_todolist/domain/repositories/repository.dart';
class TaskDetailViewModel extends ChangeNotifier {
  final TaskLocalDataSource _dataSource = TaskLocalDataSource();
  
  late TaskEntity _task;

  TaskEntity get task => _task;

  Future<void> loadTask(int taskId) async {
    _task = await _dataSource.getTaskById(taskId);
    notifyListeners();
  }

  void onAddTaskButtonPressed() {
    // Implement the logic to handle adding or updating a task
  }
}
