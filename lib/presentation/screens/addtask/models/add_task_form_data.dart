import 'package:flutter/material.dart';

/// Model class to hold add task form data
class AddTaskFormData {
  String title;
  String description;
  DateTime? dueDate;
  TimeOfDay? dueTime;
  String? priority;

  AddTaskFormData({
    this.title = '',
    this.description = '',
    this.dueDate,
    this.dueTime,
    this.priority,
  });

  /// Check if the form has valid data (at minimum, a title)
  bool isValid() {
    return title.trim().isNotEmpty;
  }

  /// Create a copy with updated fields
  AddTaskFormData copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    String? priority,
  }) {
    return AddTaskFormData(
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
    );
  }

  /// Reset all fields to default values
  void reset() {
    title = '';
    description = '';
    dueDate = null;
    dueTime = null;
    priority = null;
  }
}
