import 'package:flutter_exercise1_todolist/domain/entities/task.dart';
import 'package:flutter_exercise1_todolist/domain/repositories/repository.dart';
import 'package:flutter_exercise1_todolist/data/datasources/task_local_datasource.dart';

/// Implementation of TaskRepository for search functionality
class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _localDataSource;

  TaskRepositoryImpl({TaskLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? TaskLocalDataSource();

  @override
  Future<List<TaskEntity>> searchTasks(String query) async {
    return await _localDataSource.searchTasks(query);
  }

  @override
  Future<TaskEntity> getTaskById(int id) async {
    return await _localDataSource.getTaskById(id);
  }
}
