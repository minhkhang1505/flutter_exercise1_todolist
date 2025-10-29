import 'package:flutter/material.dart';

class DateSelectionWidget extends StatelessWidget {
  final DateTime selectedStartDate;
  final DateTime selectedDueDate;
  final VoidCallback onSelectStartDate;
  final VoidCallback onSelectDueDate;

  const DateSelectionWidget({
    super.key,
    required this.selectedStartDate,
    required this.selectedDueDate,
    required this.onSelectStartDate,
    required this.onSelectDueDate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Start Date", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Due Date", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ActionChip(
                onPressed: onSelectStartDate,
                label: Text(
                  "${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year}",
                ),
              ),
              Icon(Icons.arrow_right),
              ActionChip(
                onPressed: onSelectDueDate,
                label: Text(
                  "${selectedDueDate.day}/${selectedDueDate.month}/${selectedDueDate.year}",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
