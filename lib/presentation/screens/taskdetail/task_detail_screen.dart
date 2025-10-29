import 'package:flutter/material.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedDueDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void showRenameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController renameController = TextEditingController(
          text: _titleController.text,
        );
        return AlertDialog(
          title: Text('Rename Task'),
          content: TextField(
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: null,
            expands: false,
            controller: renameController,
            decoration: InputDecoration(hintText: "Enter new task title"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle rename logic here
                setState(() {
                  _titleController.text = renameController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showRedescriptionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController redescriptionController =
            TextEditingController(text: _descriptionController.text);
        return AlertDialog(
          title: Text('Redescription Task'),
          content: TextField(
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: null,
            expands: false,
            controller: redescriptionController,
            decoration: InputDecoration(hintText: "Enter new task description"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle redescription logic here
                setState(() {
                  _descriptionController.text = redescriptionController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _selectStartDate(BuildContext context) async {
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

  void _selectDueDate(BuildContext context) async {
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

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz),
            onSelected: (value) {
              if (value == 'rename') {
                showRenameDialog();
              } else if (value == 'redescription') {
                showRedescriptionDialog();
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
                Container(
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
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: "Text title",
                          border: InputBorder.none,
                        ),
                        style: Theme.of(context).textTheme.headlineSmall,
                        readOnly: true,
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: null,
                        expands: false,
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: "Task description goes here...",
                          border: InputBorder.none,
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.bookmark, color: colorScheme.primary),
                    Text("Priority"),
                  ],
                ),
                SizedBox(height: 12),
                Container(
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
                          Text(
                            "Start Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Due Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ActionChip(
                            onPressed: () => _selectStartDate(context),
                            label: Text(
                              "${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year}",
                            ),
                          ),
                          Icon(Icons.arrow_right),
                          ActionChip(
                            onPressed: () => _selectDueDate(context),
                            label: Text(
                              "${selectedDueDate.day}/${selectedDueDate.month}/${selectedDueDate.year}",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.alarm),
                      SizedBox(width: 4),
                      Text(
                        "Deadline: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: Text(
                          "${selectedTime.hour}:${selectedTime.minute}, ${selectedDueDate.day}/${selectedDueDate.month}/${selectedDueDate.year}",
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "The reminder is set default for 10 minutes before the due date",
                  style: TextStyle(color: Colors.grey),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}