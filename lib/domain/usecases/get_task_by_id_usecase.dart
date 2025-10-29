import 'package:flutter_exercise1_todolist/domain/entities/task.dart';
import 'package:flutter_exercise1_todolist/domain/repositories/repository.dart';

class GetTaskByIdUseCase {
  final TaskRepository _repository;

  GetTaskByIdUseCase(this._repository);

  Future<TaskEntity> execute(int id) async {
    return await _repository.getTaskById(id);
  }
}
