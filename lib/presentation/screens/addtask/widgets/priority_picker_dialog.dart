import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/core/enums/priority_type.dart';

/// Dialog widget for selecting task priority
class PriorityPickerDialog extends StatelessWidget {
  const PriorityPickerDialog({super.key});

  /// Show the priority picker dialog and return the selected priority
  static Future<String?> show(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) => const PriorityPickerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              "Choose Priority",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...PriorityType.values.map(
              (priority) => _PriorityListTile(priority: priority),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual priority option in the dialog
class _PriorityListTile extends StatelessWidget {
  final PriorityType priority;

  const _PriorityListTile({required this.priority});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_capitalizeFirst(priority.name)),
      trailing: Icon(Icons.bookmark, color: priority.color),
      onTap: () {
        Navigator.of(context).pop(priority.name);
      },
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
