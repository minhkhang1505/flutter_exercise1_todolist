import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/core/enums/priority_type.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedPriority;

  void showPriorityDialog(BuildContext context) async {
    final select = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
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
                (priority) => ListTile(
                  title: Text(
                    priority.name.replaceFirst(
                      priority.name[0],
                      priority.name[0].toUpperCase(),
                    ),
                  ),
                  trailing: Icon(Icons.bookmark, color: priority.color),
                  onTap: () {
                    Navigator.of(context).pop(priority.name);
                  },
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ],
          ),
        ),
      ),
    );

    if (select != null) {
      setState(() {
        selectedPriority = select;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      helpText: 'Select Due Date',
      confirmText: 'SELECT',
      cancelText: 'CANCEL',
    );

    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Select Due Time',
      confirmText: 'SELECT',
      cancelText: 'CANCEL',
    );

    if (picked != null && picked != selectedTime) {
      setState(() => selectedTime = picked);
    }
  }

  Widget _formatPriority(String? priority) {
    if (priority == null) {
      return Row(
        children: [
          Icon(Icons.bookmark, color: Color(0xff006874)),
          SizedBox(width: 4),
          Text('Priority'),
        ],
      );
    }
    if (priority == PriorityType.high.name) {
      return Row(
        children: [
          Icon(Icons.bookmark, color: PriorityType.high.color),
          SizedBox(width: 4),
          Text('High'),
        ],
      );
    } else if (priority == PriorityType.medium.name) {
      return Row(
        children: [
          Icon(Icons.bookmark, color: PriorityType.medium.color),
          SizedBox(width: 4),
          Text('Medium'),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(Icons.bookmark, color: PriorityType.low.color),
          SizedBox(width: 4),
          Text('Low'),
        ],
      );
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Date';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final selectedDay = DateTime(date.year, date.month, date.day);
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
    if (selectedDay == today) {
      return 'Today';
    } else if (selectedDay == tomorrow) {
      return 'Tomorrow';
    } else if (selectedDay.year > now.year) {
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } else {
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) {
      return 'Time';
    }
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
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
        padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceBright,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "e.g., Research Artificial Intelligence",
                  hintStyle: TextStyle(
                    color: Colors.grey.withAlpha(250),
                    fontSize: 20,
                  ),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(
                    color: Colors.grey.withAlpha(250),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //date picker
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: colorScheme.surface,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: colorScheme.primary.withAlpha(100),
                          width: 1,
                        ),
                      ),
                    ),
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month),
                        const SizedBox(width: 8),
                        Text(_formatDate(selectedDate)),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: colorScheme.surface,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: colorScheme.primary.withAlpha(100),
                          width: 1,
                        ),
                      ),
                    ),
                    onPressed: () {
                      _selectTime(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.alarm),
                        SizedBox(width: 8),
                        Text(_formatTime(selectedTime)),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),

                  // priority picker
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: colorScheme.surface,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),

                        side: BorderSide(
                          color: colorScheme.primary.withAlpha(100),
                          width: 1,
                        ),
                      ),
                    ),

                    onPressed: () {
                      showPriorityDialog(context);
                    },
                    child: _formatPriority(selectedPriority),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: CircleBorder(
                      side: BorderSide(
                        color: colorScheme.primary.withAlpha(100),
                        width: 1,
                      ),
                    ),
                  ),
                  label: Icon(
                    Icons.arrow_upward,
                    size: 24,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
