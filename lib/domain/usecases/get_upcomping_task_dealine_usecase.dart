import 'package:flutter_exercise1_todolist/domain/entities/task.dart';
import 'package:flutter_exercise1_todolist/domain/repositories/repository.dart';

class GetUpcomingDeadlineTasksUseCase {
  final TaskRepository _repository;

  GetUpcomingDeadlineTasksUseCase(this._repository);

  Future<List<TaskEntity>> call() async {
    final allTasks = await _repository.getTasks();

    final now = DateTime.now();

    return allTasks.where((task) {
      if (task.deadline == null || task.dueDate == null) {
        return false;
      }

      final deadlineTime = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
        task.deadline!.hour,
        task.deadline!.minute,
      );
      return deadlineTime.isAfter(now) &&
          deadlineTime.isBefore(now.add(const Duration(hours: 1)));
    }).toList();
  }
}
