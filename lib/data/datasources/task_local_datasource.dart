import 'package:flutter_exercise1_todolist/core/enums/priority_type.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';

/// Local data source for tasks (in-memory storage)
/// In a real app, this would connect to a database or API
class TaskLocalDataSource {
  static final TaskLocalDataSource _instance = TaskLocalDataSource._internal();

  factory TaskLocalDataSource() => _instance;

  TaskLocalDataSource._internal();

  /// Get sample tasks for demonstration
  List<TaskEntity> getSampleTasks() {
    return [
      // Today's tasks (3 tasks)
      TaskEntity(
        id: 1,
        title: 'Walk the dog',
        description: 'Evening walk in the park',
        dueDate: DateTime.now(),
        priorityType: PriorityType.low,
        isCompleted: true,
      ),
      TaskEntity(
        id: 2,
        title: 'Team meeting',
        description: 'Weekly sprint planning meeting at 2 PM',
        dueDate: DateTime.now(),
        priorityType: null,
      ),
      TaskEntity(
        id: 3,
        title: 'Reply to emails',
        description: 'Check and respond to pending emails',
        dueDate: DateTime.now(),
        priorityType: PriorityType.medium,
      ),
      // Future tasks (4 tasks)
      TaskEntity(
        id: 4,
        title: 'Buy groceries',
        description: 'Milk, Bread, Eggs, Butter',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        priorityType: PriorityType.medium,
      ),
      TaskEntity(
        id: 5,
        title: 'Pay bills',
        description: 'Electricity and water bills due soon',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        priorityType: PriorityType.high,
      ),
      TaskEntity(
        id: 6,
        title: 'Finish project report',
        description: 'Complete the final draft of the project report',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        priorityType: PriorityType.high,
      ),
      TaskEntity(
        id: 7,
        title: 'Read a book',
        description: 'Finish reading "Clean Code" chapter 5-8',
        dueDate: null,
        priorityType: PriorityType.low,
      ),
    ];
  }

  Future<List<TaskEntity>> searchTasks(String query) async {
    final allTasks = getSampleTasks();
    return allTasks
        .where(
          (task) =>
              task.title.toLowerCase().contains(query.toLowerCase()) ||
              task.description.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  /// Get all tasks
  /// In a real app, this would fetch from a database
  Future<List<TaskEntity>> getTasks() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    return getSampleTasks();
  }

  /// Get task by ID
  Future<TaskEntity> getTaskById(int id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final allTasks = getSampleTasks();
    return allTasks.firstWhere((task) => task.id == id);
  }

  /// Add a new task
  Future<void> addTask(TaskEntity task) async {
    // TODO: Implement actual storage
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Update an existing task
  Future<void> updateTask(TaskEntity task) async {
    // TODO: Implement actual storage
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Delete a task
  Future<void> deleteTask(int taskId) async {
    // TODO: Implement actual storage
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
