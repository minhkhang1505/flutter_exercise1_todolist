import 'package:flutter_exercise1_todolist/core/enums/priority_type.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';

/// Local data source for tasks (in-memory storage)
/// In a real app, this would connect to a database or API
class TaskLocalDataSource {
  static final TaskLocalDataSource _instance = TaskLocalDataSource._internal();

  factory TaskLocalDataSource() => _instance;

  TaskLocalDataSource._internal();

  /// Get sample tasks for demonstration
  List<Task> getSampleTasks() {
    return [
      // Today's tasks (3 tasks)
      Task(
        title: 'Walk the dog',
        description: 'Evening walk in the park',
        dueDate: DateTime.now(),
        priorityType: PriorityType.low,
        isCompleted: true,
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
        dueDate: null,
        priorityType: PriorityType.low,
      ),
    ];
  }

  /// Get all tasks
  /// In a real app, this would fetch from a database
  Future<List<Task>> getTasks() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    return getSampleTasks();
  }

  /// Add a new task
  Future<void> addTask(Task task) async {
    // TODO: Implement actual storage
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Update an existing task
  Future<void> updateTask(Task task) async {
    // TODO: Implement actual storage
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Delete a task
  Future<void> deleteTask(int taskId) async {
    // TODO: Implement actual storage
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
