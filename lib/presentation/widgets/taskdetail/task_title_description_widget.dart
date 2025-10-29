import 'package:flutter/material.dart';

class TaskTitleDescriptionWidget extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const TaskTitleDescriptionWidget({
    super.key,
    required this.titleController,
    required this.descriptionController,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: null,
            expands: false,
            controller: titleController,
            decoration: InputDecoration(
              hintText: "Text title",
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
            readOnly: true,
          ),
          TextField(
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: null,
            expands: false,
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: "Task description goes here...",
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            readOnly: true,
          ),
        ],
      ),
    );
  }
}
