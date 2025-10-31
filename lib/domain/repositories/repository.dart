import '../entities/task.dart';

/// Abstract repository interface for task operations
abstract class TaskRepository {
  Future<List<TaskEntity>> searchTasks(String query);
  Future<TaskEntity> getTaskById(int id);
  Future<int> addTask(TaskEntity task);
  Future<List<TaskEntity>> getTasks();
  Future<void> deleteTask(int id);
}
