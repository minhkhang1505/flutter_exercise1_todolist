import 'package:flutter/material.dart';

class DeadlineWidget extends StatelessWidget {
  final TimeOfDay selectedTime;
  final DateTime selectedDueDate;
  final VoidCallback onSelectTime;

  const DeadlineWidget({
    super.key,
    required this.selectedTime,
    required this.selectedDueDate,
    required this.onSelectTime,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Icon(Icons.alarm),
          SizedBox(width: 4),
          Text("Deadline: ", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          GestureDetector(
            onTap: onSelectTime,
            child: Text(
              "${selectedTime.hour}:${selectedTime.minute}, ${selectedDueDate.day}/${selectedDueDate.month}/${selectedDueDate.year}",
            ),
          ),
        ],
      ),
    );
  }
}
