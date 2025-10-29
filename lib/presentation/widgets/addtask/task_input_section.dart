import 'package:flutter/material.dart';
import '../addtask/task_input_field.dart';

class TaskInputSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const TaskInputSection({
    super.key,
    required this.titleController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: TaskInputField(
            hintText: "e.g., Research Artificial Intelligence",
            fontSize: 20,
            controller: titleController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TaskInputField(
            hintText: "Description",
            fontSize: 16,
            controller: descriptionController,
          ),
        ),
      ],
    );
  }
}
