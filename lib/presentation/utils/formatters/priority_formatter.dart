import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/core/enums/priority_type.dart';

/// Utility class for formatting priority display
class PriorityFormatter {
  /// Get the display widget for a priority
  static Widget formatPriorityWidget(String? priority, Color defaultColor) {
    if (priority == null) {
      return Row(
        children: [
          Icon(Icons.bookmark, color: defaultColor),
          const SizedBox(width: 4),
          const Text('Priority'),
        ],
      );
    }

    final priorityType = _getPriorityType(priority);
    final displayName = _capitalizeFirst(priority);

    return Row(
      children: [
        Icon(Icons.bookmark, color: priorityType?.color ?? defaultColor),
        const SizedBox(width: 4),
        Text(displayName),
      ],
    );
  }

  /// Get the priority type enum from string name
  static PriorityType? _getPriorityType(String priority) {
    return PriorityType.values.firstWhere(
      (type) => type.name == priority,
      orElse: () => PriorityType.low,
    );
  }

  /// Capitalize the first letter of a string
  static String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Get the display name for a priority
  static String getDisplayName(String? priority) {
    if (priority == null) return 'Priority';
    return _capitalizeFirst(priority);
  }
}
