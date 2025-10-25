import '../entities/task.dart';

/// Abstract repository interface for task operations
abstract class TaskRepository {
  Future<List<TaskEntity>> searchTasks(String query);
}
