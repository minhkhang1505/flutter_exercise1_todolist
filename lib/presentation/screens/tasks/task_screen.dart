import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with TickerProviderStateMixin {
  late TabController _controller;

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
        title: const Text('Tasks'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLow,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
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
                                    const SizedBox(height: 4),
                                    Text(
                                      task.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    // Today Tasks Tab
                    Center(
                      child: Text(
                        'Today\'s Tasks',
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ),
                    // Upcoming Tasks Tab
                    Center(
                      child: Text(
                        'Upcoming Tasks',
                        style: TextStyle(color: colorScheme.primary),
                      ),
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

enum PriorityType { low, medium, high }

class Task {
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
  Task(
    title: 'Buy groceries',
    description: 'Milk, Bread, Eggs, Butter',
    dueDate: DateTime.now().add(const Duration(days: 1)),
    priorityType: PriorityType.medium,
  ),
  Task(
    title: 'Walk the dog',
    description: 'Evening walk in the park',
    dueDate: DateTime.now(),
    priorityType: PriorityType.low,
  ),
  Task(
    title: 'Finish project report',
    description: 'Complete the final draft of the project report',
    dueDate: DateTime.now().add(const Duration(days: 3)),
    priorityType: PriorityType.high,
  ),
];
