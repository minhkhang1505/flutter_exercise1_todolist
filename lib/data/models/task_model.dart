import 'package:flutter_exercise1_todolist/domain/entities/task.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    required super.id,
    required super.title,
    required super.description,
    super.dueDate,
    super.priorityType,
    super.isCompleted,
  });

  TaskEntity toEntity() => TaskEntity(
    id: id,
    title: title,
    description: description,
    dueDate: dueDate,
    isCompleted: isCompleted,
    priorityType: priorityType,
  );

  static TaskModel fromEntity(TaskEntity entity) => TaskModel(
    id: entity.id,
    title: entity.title,
    description: entity.description,
    dueDate: entity.dueDate,
    isCompleted: entity.isCompleted,
    priorityType: entity.priorityType,
  );
}
