import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/data/repositories/repository_implement.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';

class TaskDetailViewModel extends ChangeNotifier {
  final TaskRepositoryImpl _dataSource = TaskRepositoryImpl();

  late TaskEntity _task;

  TaskEntity get task => _task;

  Future<void> loadTask(int taskId) async {
    _task = await _dataSource.getTaskById(taskId);
    notifyListeners();
  }

  void onAddTaskButtonPressed() {
    // Implement the logic to handle adding or updating a task
  }

  Future<void> onDeleteTaskButtonPressed(int taskId) async {
    await _dataSource.deleteTask(taskId);
    notifyListeners();
  }

  Future<void> updateTask(TaskEntity updatedTask) async {
    await _dataSource.updateTask(updatedTask);
    _task = updatedTask;
    notifyListeners();
  }
}
