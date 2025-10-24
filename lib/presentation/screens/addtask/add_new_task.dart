import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/presentation/screens/addtask/models/add_task_form_data.dart';
import 'package:flutter_exercise1_todolist/presentation/screens/addtask/utils/date_time_formatter.dart';
import 'package:flutter_exercise1_todolist/presentation/screens/addtask/utils/priority_formatter.dart';
import 'package:flutter_exercise1_todolist/presentation/screens/addtask/widgets/priority_picker_dialog.dart';
import 'package:flutter_exercise1_todolist/presentation/screens/addtask/widgets/task_action_button.dart';
import 'package:flutter_exercise1_todolist/presentation/screens/addtask/widgets/task_input_field.dart';
import 'package:flutter_exercise1_todolist/presentation/screens/addtask/widgets/task_submit_button.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formData = AddTaskFormData();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Show priority picker dialog
  Future<void> _showPriorityDialog() async {
    final selected = await PriorityPickerDialog.show(context);
    if (selected != null) {
      setState(() {
        _formData.priority = selected;
      });
    }
  }

  /// Show date picker dialog
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _formData.dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      helpText: 'Select Due Date',
      confirmText: 'SELECT',
      cancelText: 'CANCEL',
    );

    if (picked != null) {
      setState(() {
        _formData.dueDate = picked;
      });
    }
  }

  /// Show time picker dialog
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _formData.dueTime ?? TimeOfDay.now(),
      helpText: 'Select Due Time',
      confirmText: 'SELECT',
      cancelText: 'CANCEL',
    );

    if (picked != null) {
      setState(() {
        _formData.dueTime = picked;
      });
    }
  }

  /// Handle form submission
  void _handleSubmit() {
    _formData.title = _titleController.text;
    _formData.description = _descriptionController.text;

    if (!_formData.isValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    // TODO: Save the task using a repository or provider
    // For now, just close the bottom sheet
    Navigator.of(context).pop(_formData);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceBright,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInputFields(),
            _buildActionButtons(colorScheme),
            _buildSubmitButton(colorScheme),
          ],
        ),
      ),
    );
  }

  /// Build title and description input fields
  Widget _buildInputFields() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: TaskInputField(
            hintText: "e.g., Research Artificial Intelligence",
            fontSize: 20,
            controller: _titleController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TaskInputField(
            hintText: "Description",
            fontSize: 16,
            controller: _descriptionController,
          ),
        ),
      ],
    );
  }

  /// Build date, time, and priority action buttons
  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TaskActionButton(
            colorScheme: colorScheme,
            onPressed: _selectDate,
            child: Row(
              children: [
                const Icon(Icons.calendar_month),
                const SizedBox(width: 8),
                Text(DateTimeFormatter.formatDate(_formData.dueDate)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TaskActionButton(
            colorScheme: colorScheme,
            onPressed: _selectTime,
            child: Row(
              children: [
                const Icon(Icons.alarm),
                const SizedBox(width: 8),
                Text(DateTimeFormatter.formatTime(_formData.dueTime)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TaskActionButton(
            colorScheme: colorScheme,
            onPressed: _showPriorityDialog,
            child: PriorityFormatter.formatPriorityWidget(
              _formData.priority,
              colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Build submit button
  Widget _buildSubmitButton(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TaskSubmitButton(colorScheme: colorScheme, onPressed: _handleSubmit),
      ],
    );
  }
}
