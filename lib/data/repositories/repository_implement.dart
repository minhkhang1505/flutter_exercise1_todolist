import 'package:flutter_exercise1_todolist/data/datasources/local/task_sqlite_datasource.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';
import 'package:flutter_exercise1_todolist/domain/repositories/repository.dart';

/// Implementation of TaskRepository for search functionality
class TaskRepositoryImpl implements TaskRepository {
  //final TaskLocalDataSource _localDataSource;
  final TaskSqliteDatasource _sqliteDatasource;

  TaskRepositoryImpl({TaskSqliteDatasource? sqliteDatasource})
    : _sqliteDatasource = sqliteDatasource ?? TaskSqliteDatasource();

  @override
  Future<List<TaskEntity>> searchTasks(String query) async {
    return await _sqliteDatasource.searchTasks(query);
  }

  @override
  Future<TaskEntity> getTaskById(int id) async {
    return await _sqliteDatasource.getTaskById(id);
  }

  @override
  Future<int> addTask(TaskEntity task) async {
    return await _sqliteDatasource.addTask(task);
  }

  @override
  Future<List<TaskEntity>> getTasks() async {
    return await _sqliteDatasource.getTasks();
  }

  @override
  Future<void> deleteTask(int id) async {
    return await _sqliteDatasource.deleteTask(id);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    return await _sqliteDatasource.updateTask(task);
  }

  @override
  Future<void> completeTask(int id) async {
    TaskEntity task = await _sqliteDatasource.getTaskById(id);
    TaskEntity updatedTask = task.copyWith(isCompleted: true);
    await _sqliteDatasource.updateTask(updatedTask);
  }
}
