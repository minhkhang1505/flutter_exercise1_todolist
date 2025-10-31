import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/presentation/viewmodels/add_task_viewmodel.dart';
import '../../models/add_task_form_data.dart';
import '../../widgets/addtask/priority_picker_dialog.dart';
import '../../widgets/addtask/task_input_section.dart';
import '../../widgets/addtask/task_action_section.dart';
import '../../widgets/addtask/task_submit_section.dart';
import 'package:provider/provider.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen>
    with TickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formData = AddTaskFormData();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _showPriorityDialog() async {
    final selected = await PriorityPickerDialog.show(context);
    if (selected != null) {
      setState(() {
        _formData.priority = selected;
      });
    }
  }

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

  Future<void> _handleSubmit() async {
    final viewModel = context.read<AddTaskViewmodel>();
    _formData.title = _titleController.text;
    _formData.description = _descriptionController.text;

    if (!_formData.isValid()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a task title')),
        );
      }
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Adding task...')));
    }

    final success = await viewModel.addNewTask(_formData);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task added successfully!')));
      Navigator.of(context).pop(true); // Return true to trigger reload
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task: ${viewModel.error}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddTaskViewmodel>();
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
            TaskInputSection(
              titleController: _titleController,
              descriptionController: _descriptionController,
            ),
            TaskActionSection(
              dueDate: _formData.dueDate,
              dueTime: _formData.dueTime,
              priority: _formData.priority,
              onSelectDate: _selectDate,
              onSelectTime: _selectTime,
              onSelectPriority: _showPriorityDialog,
            ),
            TaskSubmitSection(
              colorScheme: colorScheme,
              onSubmit: viewModel.isLoading ? null : _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
