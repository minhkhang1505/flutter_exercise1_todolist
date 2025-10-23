import 'package:flutter/material.dart';

/// Enum representing the priority level of a task
enum PriorityType {
  low(Colors.green),
  medium(Colors.yellow),
  high(Colors.red);

  final Color color;
  const PriorityType(this.color);
}
