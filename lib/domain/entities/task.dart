import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/core/enums/priority_type.dart';

/// Task entity representing a todo item
class TaskEntity {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;
  // Nullable fields
  final DateTime? dueDate;
  final DateTime? startDate;
  final TimeOfDay? deadline;
  final PriorityType? priorityType;

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.startDate,
    required this.deadline,
    this.isCompleted = false,
    required this.priorityType,
  });

  /// Create a copy of this task with updated fields
  TaskEntity copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? startDate,
    TimeOfDay? deadline,
    bool? isCompleted,
    PriorityType? priorityType,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      startDate: startDate ?? this.startDate,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
      priorityType: priorityType ?? this.priorityType,
    );
  }
}
