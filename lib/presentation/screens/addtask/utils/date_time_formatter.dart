import 'package:flutter/material.dart';

/// Utility class for formatting dates and times in the add task screen
class DateTimeFormatter {
  /// Format a date to display as "Today", "Tomorrow", or "Oct 24"
  static String formatDate(DateTime? date) {
    if (date == null) {
      return 'Date';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (selectedDay == today) {
      return 'Today';
    } else if (selectedDay == tomorrow) {
      return 'Tomorrow';
    }

    // Format as "Oct 24" or "Oct 24, 2026"
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    if (selectedDay.year > now.year) {
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } else {
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  /// Format a time to display as "2:30 PM"
  static String formatTime(TimeOfDay? time) {
    if (time == null) {
      return 'Time';
    }

    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
  }

  /// Combine date and time into a single DateTime
  static DateTime? combineDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null) return null;
    if (time == null) return date;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
