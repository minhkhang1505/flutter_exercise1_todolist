import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with TickerProviderStateMixin {
  late TabController _controller;

  // Map to track completion status of each task by ID
  final Map<int, bool> _completedTasks = {};

  void toggleTaskCompletion(int taskId, bool? value) {
    setState(() {
      _completedTasks[taskId] = value ?? false;
    });
  }

  bool isTaskCompleted(int taskId) {
    return _completedTasks[taskId] ?? false;
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
                          isCompleted: isTaskCompleted(task.id),
                          onChanged: (value) =>
                              toggleTaskCompletion(task.id, value),
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
                          final task = todayTasks[index];
                          return TaskItem(
                            task: task,
                            isCompleted: isTaskCompleted(task.id),
                            onChanged: (value) =>
                                toggleTaskCompletion(task.id, value),
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
                          final task = upcomingTasks[index];
                          return TaskItem(
                            task: task,
                            isCompleted: isTaskCompleted(task.id),
                            onChanged: (value) =>
                                toggleTaskCompletion(task.id, value),
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

  // Helper function to check if two dates are on the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: colorScheme.primaryContainer),
        color: colorScheme.primaryContainer.withAlpha(50),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? colorScheme.onSurfaceVariant : null,
                  ),
                ),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 12),
                if (isSameDay(task.dueDate, DayCategory.today.date))
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 12,
                      color: DayCategory.today.color,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else if (isSameDay(task.dueDate, DayCategory.tomorrow.date))
                  Text(
                    'Tomorrow',
                    style: TextStyle(
                      fontSize: 12,
                      color: DayCategory.tomorrow.color,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  Text(
                    'Due: ${task.dueDate.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(fontSize: 12, color: Colors.purple),
                  ),
              ],
            ),
          ),
          if (task.priorityType != null)
            Icon(
              Icons.bookmark,
              color: task.priorityType?.color.withAlpha(200),
            ),
        ],
      ),
    );
  }
}

enum DayCategory {
  today(0, "Today", Colors.green),
  tomorrow(1, "Tomorrow", Colors.orange);

  final int offsetDays;
  final String label;
  final Color color;

  const DayCategory(this.offsetDays, this.label, this.color);

  /// Hàm getter tính ngày thật tại runtime
  DateTime get date => DateTime.now().add(Duration(days: offsetDays));
}

enum PriorityType {
  low(Colors.green),
  medium(Colors.yellow),
  high(Colors.red);

  final Color color;
  const PriorityType(this.color);
}

class Task {
  final int id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final PriorityType? priorityType;

  Task({
    int? id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    required this.priorityType,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch + title.hashCode;
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
    priorityType: null,
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
