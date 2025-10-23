# Development Guide for Tasks Feature

## 📋 File Responsibilities

### Domain Layer (`lib/domain/`)

**Purpose:** Business logic and entities (platform-independent)

- `entities/task.dart`: Core Task model
  - Contains only business logic
  - No Flutter dependencies
  - Includes `copyWith` for immutability

### Data Layer (`lib/data/`)

**Purpose:** Data access and storage

- `datasources/task_local_datasource.dart`: Local data management
  - Singleton pattern for shared instance
  - Ready to integrate with databases
  - Currently provides sample data
  - Mock methods for CRUD operations

### Core Layer (`lib/core/`)

**Purpose:** Shared utilities, constants, and helpers

- `enums/priority_type.dart`: Task priority levels
- `enums/day_category.dart`: Date category helpers
- `utils/task_filters.dart`: Filtering and querying utilities
  - Pure functions (no side effects)
  - Easy to test
  - Reusable across the app

### Presentation Layer (`lib/presentation/`)

**Purpose:** UI components and screens

- `screens/tasks/task_screen.dart`: Main tasks screen
  - Manages state and user interactions
  - Coordinates between widgets
  - Handles navigation
- `screens/tasks/widgets/task_item.dart`: Individual task card
  - Self-contained and reusable
  - Handles its own layout
  - Receives callbacks for interactions
- `screens/tasks/widgets/custom_tab_bar.dart`: Tab navigation
  - Generic and reusable
  - Configurable tabs list
  - Theme-aware styling
- `screens/tasks/widgets/task_list_view.dart`: Task list display
  - Handles empty states
  - Manages scrolling
  - Delegates item rendering to TaskItem

## 🛠️ Common Development Scenarios

### Scenario 1: Add a New Task Property

**Example:** Add a "category" field

1. Update the entity:

```dart
// lib/domain/entities/task.dart
class Task {
  final String? category; // Add new field

  Task({
    // ... existing fields
    this.category,
  });

  Task copyWith({
    // ... existing fields
    String? category,
  }) {
    return Task(
      // ... existing fields
      category: category ?? this.category,
    );
  }
}
```

2. Update the data source:

```dart
// lib/data/datasources/task_local_datasource.dart
Task(
  title: 'Example',
  // ... existing fields
  category: 'Work', // Add to sample data
)
```

3. Update the UI (if needed):

```dart
// lib/presentation/screens/tasks/widgets/task_item.dart
if (task.category != null)
  Chip(label: Text(task.category!)),
```

### Scenario 2: Add a New Filter

**Example:** Filter by priority

1. Add filter utility:

```dart
// lib/core/utils/task_filters.dart
static List<Task> getHighPriorityTasks(List<Task> tasks) {
  return tasks
      .where((task) => task.priorityType == PriorityType.high)
      .toList();
}
```

2. Use in screen:

```dart
// lib/presentation/screens/tasks/task_screen.dart
List<Task> _getFilteredTasks(int tabIndex) {
  switch (tabIndex) {
    case 3: // New tab
      return TaskFilters.getHighPriorityTasks(_tasks);
    // ... existing cases
  }
}
```

3. Update tab bar:

```dart
CustomTabBar(
  controller: _tabController,
  tabs: const ['All', 'Today', 'Upcoming', 'High Priority'],
)
```

### Scenario 3: Add State Management (Provider Example)

1. Create a provider:

```dart
// lib/presentation/providers/task_provider.dart
import 'package:flutter/foundation.dart';

class TaskProvider extends ChangeNotifier {
  final TaskLocalDataSource _dataSource = TaskLocalDataSource();
  List<Task> _tasks = [];
  Map<int, bool> _completedTasks = {};

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await _dataSource.getTasks();
    notifyListeners();
  }

  void toggleTask(int taskId, bool? value) {
    _completedTasks[taskId] = value ?? false;
    notifyListeners();
  }

  bool isCompleted(int taskId) {
    return _completedTasks[taskId] ?? false;
  }
}
```

2. Update the screen:

```dart
// lib/presentation/screens/tasks/task_screen.dart
import 'package:provider/provider.dart';

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider()..loadTasks(),
      child: _TasksScreenContent(),
    );
  }
}

class _TasksScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    // Use provider.tasks instead of local state
  }
}
```

### Scenario 4: Add Database Integration

1. Create a repository interface:

```dart
// lib/domain/repositories/task_repository.dart
abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(int taskId);
}
```

2. Implement with your database:

```dart
// lib/data/repositories/task_repository_impl.dart
class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _localDataSource;
  // Add database instance (SQLite, Hive, etc.)

  @override
  Future<List<Task>> getTasks() async {
    // Fetch from database
  }

  // Implement other methods...
}
```

## 🧪 Testing Guidelines

### Unit Tests

```dart
// test/core/utils/task_filters_test.dart
void main() {
  group('TaskFilters', () {
    test('getTodayTasks returns only today tasks', () {
      final tasks = [
        Task(title: 'Today', dueDate: DateTime.now()),
        Task(title: 'Tomorrow', dueDate: DateTime.now().add(Duration(days: 1))),
      ];

      final result = TaskFilters.getTodayTasks(tasks);

      expect(result.length, 1);
      expect(result.first.title, 'Today');
    });
  });
}
```

### Widget Tests

```dart
// test/presentation/widgets/task_item_test.dart
void main() {
  testWidgets('TaskItem displays task information', (tester) async {
    final task = Task(
      title: 'Test Task',
      description: 'Test Description',
      dueDate: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: TaskItem(
          task: task,
          isCompleted: false,
          onChanged: (_) {},
        ),
      ),
    );

    expect(find.text('Test Task'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
  });
}
```

## 🚀 Performance Tips

1. **Use const constructors** where possible
2. **Avoid rebuilding** entire lists when only one item changes
3. **Lazy loading** for large task lists
4. **Memoization** for expensive filters
5. **Debouncing** for search/filter inputs

## 📝 Code Style Conventions

- Use clear, descriptive names
- Add doc comments for public APIs
- Keep widgets small and focused
- Prefer composition over inheritance
- Use immutable data structures
- Handle null safety properly
- Follow Flutter/Dart style guide

## 🔧 Recommended Next Steps

1. Add unit tests for `TaskFilters`
2. Add widget tests for components
3. Implement actual database storage
4. Add state management (Provider/Riverpod)
5. Create add/edit task screens
6. Add task deletion functionality
7. Implement search and sort features
8. Add animations and polish
