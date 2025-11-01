import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/presentation/viewmodels/task_detail_viewmodel.dart';
import '../../widgets/taskdetail/task_title_description_widget.dart';
import '../../widgets/taskdetail/priority_widget.dart';
import '../../widgets/taskdetail/date_selection_widget.dart';
import '../../widgets/taskdetail/deadline_widget.dart';
import '../../widgets/taskdetail/reminder_text_widget.dart';
import '../../widgets/taskdetail/rename_dialog.dart';
import '../../widgets/taskdetail/redescription_dialog.dart';
import '../../widgets/taskdetail/danger_button.dart';
import 'package:provider/provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final int taskId;
  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen>
    with TickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? selectedStartDate;
  DateTime? selectedDueDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskDetailViewModel>().loadTask(widget.taskId).then((_) {
        final task = context.read<TaskDetailViewModel>().task;
        if (mounted) {
          setState(() {
            _titleController.text = task.title;
            _descriptionController.text = task.description;
            selectedStartDate = task.startDate;
            selectedDueDate = task.dueDate;
            selectedTime = task.deadline;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showRenameDialog() {
    showDialog(
      context: context,
      builder: (context) => RenameDialog(
        initialTitle: _titleController.text,
        onSave: (newTitle) {
          setState(() {
            _titleController.text = newTitle;
          });
        },
      ),
    );
  }

  void _showRedescriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => RedescriptionDialog(
        initialDescription: _descriptionController.text,
        onSave: (newDescription) {
          setState(() {
            _descriptionController.text = newDescription;
          });
        },
      ),
    );
  }

  void _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
      });
    }
  }

  void _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDueDate) {
      setState(() {
        selectedDueDate = picked;
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _deleteTask() async {
    await context.read<TaskDetailViewModel>().onDeleteTaskButtonPressed(
      widget.taskId,
    );
    if (mounted) {
      Navigator.pop(
        context,
        'deleted',
      ); // Return 'deleted' to trigger parent reload
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz),
            onSelected: (value) {
              if (value == 'rename') {
                _showRenameDialog();
              } else if (value == 'redescription') {
                _showRedescriptionDialog();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'rename', child: Text('Rename')),
              PopupMenuItem(
                value: 'redescription',
                child: Text('Redescription'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TaskTitleDescriptionWidget(
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                ),
                SizedBox(height: 24),
                PriorityWidget(),
                SizedBox(height: 12),
                DateSelectionWidget(
                  selectedStartDate: selectedStartDate,
                  selectedDueDate: selectedDueDate,
                  onSelectStartDate: _selectStartDate,
                  onSelectDueDate: _selectDueDate,
                ),
                SizedBox(height: 12),
                DeadlineWidget(
                  selectedTime: selectedTime,
                  selectedDueDate: selectedDueDate,
                  onSelectTime: _selectTime,
                ),
                ReminderTextWidget(),
                SizedBox(height: 24),
                DangerButton(label: 'Delete', onPressed: _deleteTask),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
