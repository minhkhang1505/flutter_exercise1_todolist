import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with TickerProviderStateMixin {
  late TabController _controller;
  bool isCompleted = false;

  void onChanged(bool? value) {
    setState(() {
      isCompleted = value!;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
          child: Column(
            children: [
              // TabBar for all / today / upcoming options
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  height: 45,
                  color: colorScheme.surfaceContainerHigh,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TabBar(
                      controller: _controller,
                      indicator: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      labelColor: colorScheme.onPrimary,
                      unselectedLabelColor: colorScheme.primary,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'Today'),
                        Tab(text: 'Upcoming'),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _controller,
                  children: <Widget>[
                    // All Tasks Tab
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: sampleTasks.length,
                      itemBuilder: (context, index) {
                        final task = sampleTasks[index];
                        return TaskItem(
                          task: task,
                          isCompleted: isCompleted,
                          onChanged: onChanged,
                        );
                      },
                    ),
                    // Today Tasks Tab
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: sampleTasks.where((task) {
                        return task.dueDate.day == DateTime.now().day &&
                            task.dueDate.month == DateTime.now().month &&
                            task.dueDate.year == DateTime.now().year;
                      }).length,
                      itemBuilder: (context, index) {
                        final todayTasks = sampleTasks.where((task) {
                          return task.dueDate.day == DateTime.now().day &&
                              task.dueDate.month == DateTime.now().month &&
                              task.dueDate.year == DateTime.now().year;
                        }).toList();

                        if (index < todayTasks.length) {
                          return TaskItem(
                            task: todayTasks[index],
                            isCompleted: isCompleted,
                            onChanged: onChanged,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    // Upcoming Tasks Tab
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: sampleTasks.where((task) {
                        return task.dueDate.isAfter(DateTime.now());
                      }).length,
                      itemBuilder: (context, index) {
                        final upcomingTasks = sampleTasks.where((task) {
                          return task.dueDate.isAfter(DateTime.now());
                        }).toList();

                        if (index < upcomingTasks.length) {
                          return TaskItem(
                            task: upcomingTasks[index],
                            isCompleted: isCompleted,
                            onChanged: onChanged,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {
          // TODO: Add task functionality
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;
  final bool isCompleted;
  final Function(bool?) onChanged;

  const TaskItem({
    super.key,
    required this.task,
    required this.isCompleted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: colorScheme.primaryContainer),
        color: colorScheme.primaryContainer.withAlpha(50),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          Checkbox(value: isCompleted, onChanged: onChanged),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Due: ${task.dueDate.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum PriorityType { low, medium, high }

class Task {
  final int id = DateTime.now().millisecondsSinceEpoch;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final PriorityType priorityType;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    required this.priorityType,
  });
}

final List<Task> sampleTasks = [
  // Today's tasks (3 tasks)
  Task(
    title: 'Walk the dog',
    description: 'Evening walk in the park',
    dueDate: DateTime.now(),
    priorityType: PriorityType.low,
  ),
  Task(
    title: 'Team meeting',
    description: 'Weekly sprint planning meeting at 2 PM',
    dueDate: DateTime.now(),
    priorityType: PriorityType.high,
  ),
  Task(
    title: 'Reply to emails',
    description: 'Check and respond to pending emails',
    dueDate: DateTime.now(),
    priorityType: PriorityType.medium,
  ),
  // Future tasks (4 tasks)
  Task(
    title: 'Buy groceries',
    description: 'Milk, Bread, Eggs, Butter',
    dueDate: DateTime.now().add(const Duration(days: 1)),
    priorityType: PriorityType.medium,
  ),
  Task(
    title: 'Pay bills',
    description: 'Electricity and water bills due soon',
    dueDate: DateTime.now().add(const Duration(days: 2)),
    priorityType: PriorityType.high,
  ),
  Task(
    title: 'Finish project report',
    description: 'Complete the final draft of the project report',
    dueDate: DateTime.now().add(const Duration(days: 3)),
    priorityType: PriorityType.high,
  ),
  Task(
    title: 'Read a book',
    description: 'Finish reading "Clean Code" chapter 5-8',
    dueDate: DateTime.now().add(const Duration(days: 7)),
    priorityType: PriorityType.low,
  ),
];
