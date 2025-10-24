import 'package:flutter/material.dart';

/// Enum representing day categories for task filtering
enum DayCategory {
  today(0, "Today", Colors.green),
  tomorrow(1, "Tomorrow", Colors.orange),
  completed(-1, "Completed", Colors.grey);

  final int offsetDays;
  final String label;
  final Color color;

  const DayCategory(this.offsetDays, this.label, this.color);

  /// Calculate the actual date at runtime
  DateTime get date => DateTime.now().add(Duration(days: offsetDays));
}
