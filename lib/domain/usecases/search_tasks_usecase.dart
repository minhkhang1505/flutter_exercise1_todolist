import 'package:flutter_exercise1_todolist/domain/entities/task.dart';
import 'package:flutter_exercise1_todolist/domain/repositories/repository.dart';

/// Use case for searching tasks
class SearchTasksUseCase {
  final TaskRepository _repository;

  SearchTasksUseCase(this._repository);

  Future<List<TaskEntity>> execute(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    return await _repository.searchTasks(query);
  }
}
