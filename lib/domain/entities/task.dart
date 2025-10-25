import 'package:flutter_exercise1_todolist/core/enums/priority_type.dart';

/// Task entity representing a todo item
class TaskEntity {
  final int id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final bool isCompleted;
  final PriorityType? priorityType;

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    required this.priorityType,
  });

  /// Create a copy of this task with updated fields
  TaskEntity copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    PriorityType? priorityType,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      priorityType: priorityType ?? this.priorityType,
    );
  }
}
