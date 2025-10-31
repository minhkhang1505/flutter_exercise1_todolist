# Source Code Overview & SQLite Integration Plan

## 1. Project Structure & Architecture

This Flutter project follows Clean Architecture principles, separating concerns into distinct layers for maintainability, testability, and scalability. The main layers and their responsibilities are:

### **Core Layer (`lib/core/`):**

- **constants/**: Shared constant values.
- **enums/**: Enumerations (e.g., `PriorityType`, `DayCategory`).
- **errors/**: Error definitions and handling.
- **formatters/**: Utility classes for formatting dates, priorities, etc.
- **themes/**: App theming, color schemes, and typography.
- **utils/**: General utilities (e.g., task filtering logic).

### **Data Layer (`lib/data/`):**

- **datasources/**: Data source implementations. Currently, `task_local_datasource.dart` provides in-memory storage for tasks.
- **models/**: Data models for storage and network.
- **repositories/**: Repository implementations that abstract data sources.

### **Domain Layer (`lib/domain/`):**

- **entities/**: Core business entities (e.g., `TaskEntity`).
- **repositories/**: Repository interfaces (contracts for data access).
- **usecases/**: Application-specific business logic (e.g., `GetTaskByIdUseCase`).

### **Presentation Layer (`lib/presentation/`):**

- **models/**: UI-specific models (e.g., form data).
- **providers/**: (Reserved for Provider state management setup.)
- **screens/**: UI screens, organized by feature (e.g., add task, search, task detail, tasks list).
- **viewmodels/**: State management classes (using `ChangeNotifier` and Provider).
- **widgets/**: Reusable UI components, organized by feature.

## 2. State Management

- Uses the **Provider** package for dependency injection and state management.
- Each screen has a corresponding ViewModel (e.g., `TasksViewModel`, `AddTaskViewModel`, `TaskDetailViewModel`).
- ViewModels interact with repositories/data sources and notify the UI of state changes.

## 3. Features & Flow

- **Task List**: View all, today, and upcoming tasks.
- **Add Task**: Form to create a new task.
- **Task Detail**: View and edit details of a single task.
- **Search**: Search tasks by title or description.
- **Theming**: Material 3 theming with light/dark support.

## 4. Current Data Storage

- **SQLite Integration**: The app now uses SQLite for persistent offline storage via `TaskSqliteDatasource` (singleton pattern).
- **Database Schema**: Tasks are stored in a `tasks` table with columns for id, title, description, due_date, start_date, deadline_hour, deadline_minute, priority, and is_completed.
- **Migration**: Data is now persisted across app restarts, with proper mapping between `TaskEntity` and SQLite rows.
- **Fallback**: The original in-memory `TaskLocalDataSource` remains as a fallback option for testing or edge cases.

---

# Plan: Integrate SQLite for Offline Data Storage

## **A. Why SQLite?**

- Provides robust, persistent, and efficient local storage for structured data.
- Well-supported in Flutter via packages like `sqflite` or `drift`.

## **B. Migration Steps**

### 1. **Add SQLite Dependency**

- Add `sqflite` (or `drift` for advanced use) and `path_provider` to `pubspec.yaml`.

### 2. **Create SQLite Data Source**

- In `lib/data/datasources/`, add `task_sqlite_datasource.dart`.
- Implement CRUD operations for tasks using SQLite tables.
- Map between `TaskEntity` and SQLite rows.

### 3. **Update Repository Implementation**

- In `repository_implement.dart`, inject and use the SQLite data source instead of (or alongside) the in-memory data source.
- Use dependency injection to allow easy switching between data sources (for testing or fallback).

### 4. **Migrate Data Access in ViewModels**

- Update all ViewModels to use the repository abstraction (which now uses SQLite under the hood).
- Remove direct dependency on the in-memory data source.

### 5. **Data Migration (Optional)**

- If you want to preserve in-memory data on first launch, write a migration script to copy tasks from memory to SQLite.

### 6. **Testing**

- Write unit and integration tests for the SQLite data source and repository.
- Test all flows: add, update, delete, fetch, and search tasks.

### 7. **Performance & Error Handling**

- Add error handling for database operations.
- Consider using transactions for batch operations.
- Optimize queries for large data sets if needed.

### 8. **(Optional) Advanced Features**

- Add support for task attachments, reminders, or sync with cloud storage.
- Use `drift` for type-safe queries and reactive streams if your app grows in complexity.

---

## **Summary Table: Key Files to Add/Modify**

| File/Folder                                        | Purpose                              |
| -------------------------------------------------- | ------------------------------------ |
| `pubspec.yaml`                                     | Add SQLite dependencies              |
| `lib/data/datasources/task_sqlite_datasource.dart` | SQLite CRUD logic for tasks          |
| `lib/data/repositories/repository_implement.dart`  | Use SQLite data source               |
| `lib/domain/entities/task.dart`                    | Ensure entity is SQLite-compatible   |
| `lib/presentation/viewmodels/`                     | Update to use repository abstraction |
| `test/`                                            | Add tests for SQLite integration     |

---

## **References**

- [sqflite package](https://pub.dev/packages/sqflite)
- [drift package](https://pub.dev/packages/drift)
- [Flutter: Persist data with SQLite](https://docs.flutter.dev/cookbook/persistence/sqlite)

---

**This plan will enable robust, persistent offline storage for all tasks, while keeping the codebase clean, testable, and maintainable.**

---

# Plan: Implement Deadline Notification Feature

## **A. Feature Overview**

- Send local notifications 10 minutes before each task's deadline.
- Notifications should include task title and a reminder message.
- Handle notification permissions and scheduling.

## **B. Implementation Steps**

### 1. **Add Notification Dependencies**

- Add `flutter_local_notifications` and `timezone` packages to `pubspec.yaml`.
- Configure platform-specific settings (Android/iOS).

### 2. **Create Notification Service**

- In `lib/core/services/`, add `notification_service.dart`.
- Initialize notification plugin with proper settings.
- Implement methods to schedule, cancel, and show notifications.

### 3. **Update Task Entity & Data Layer**

- Ensure `TaskEntity` includes deadline information (already present).
- In `TaskSqliteDatasource`, add methods to retrieve tasks with upcoming deadlines.
- Create a use case `GetUpcomingDeadlineTasksUseCase` in the domain layer.

### 4. **Implement Notification Scheduling**

- In ViewModels (e.g., `AddTaskViewModel`, `TaskDetailViewModel`), schedule notifications when tasks are added/updated.
- Calculate notification time: `deadline - 10 minutes`.
- Use `flutter_local_notifications` to schedule notifications with unique IDs.

### 5. **Background Task Handling**

- For Android: Use `WorkManager` or periodic background tasks to check for upcoming deadlines.
- For iOS: Use background fetch or local notification scheduling.
- Create a background service to periodically check and schedule notifications.

### 6. **Permission Management**

- Request notification permissions on app launch.
- Handle permission denied scenarios gracefully.
- Add settings screen to enable/disable notifications.

### 7. **Notification Content & Actions**

- Customize notification title: "Task Due Soon: {task.title}"
- Body: "Deadline in 10 minutes - {task.description}"
- Add action to open the task detail screen when tapped.

### 8. **Testing & Edge Cases**

- Test notification scheduling and delivery.
- Handle time zone changes and device restarts.
- Test with multiple tasks having close deadlines.
- Add unit tests for notification service.

### 9. **Performance Considerations**

- Batch notification scheduling to avoid performance issues.
- Clean up old/cancelled notifications.
- Optimize database queries for upcoming deadlines.

### 10. **(Optional) Advanced Features**

- Allow users to customize notification time (e.g., 5, 10, 15 minutes before).
- Add snooze functionality.
- Integrate with system calendar for cross-app reminders.

---

## **Summary Table: Key Files for Notification Feature**

| File/Folder                                                    | Purpose                                |
| -------------------------------------------------------------- | -------------------------------------- |
| `pubspec.yaml`                                                 | Add notification dependencies          |
| `lib/core/services/notification_service.dart`                  | Notification logic and scheduling      |
| `lib/domain/usecases/get_upcoming_deadline_tasks_usecase.dart` | Fetch tasks with near deadlines        |
| `lib/presentation/viewmodels/`                                 | Schedule notifications on task changes |
| `lib/presentation/screens/settings/`                           | Notification settings screen           |
| `android/app/src/main/AndroidManifest.xml`                     | Notification permissions               |
| `ios/Runner/Info.plist`                                        | Notification permissions               |

---

## **References**

- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [Flutter Local Notifications](https://docs.flutter.dev/development/ui/widgets-intro#local-notifications)
- [Background Tasks in Flutter](https://docs.flutter.dev/development/packages-and-plugins/background-processes)

---

**This plan will enhance user experience by providing timely reminders for task deadlines, improving task completion rates.**

# Plan: Fix State Management in TasksScreen (UI Not Updating on Data Change)

## **A. Problem Overview**

- The `TasksScreen` currently creates its own instance of `TasksViewModel` and uses manual `setState` calls to update the UI after loading tasks or performing actions (add/delete).
- This approach does **not** leverage the Provider/ChangeNotifier pattern, so UI updates are not reactive to changes in the underlying data (e.g., when a task is added or deleted elsewhere, or from another screen).
- As a result, the UI may not update as expected when the data changes.

## **B. Solution: Use Provider for State Management**

### 1. **Refactor to Use Provider**

    - Wrap the `TasksScreen` (or the app root) with a `ChangeNotifierProvider` for `TasksViewModel`.
    - Remove the local instantiation of `TasksViewModel` in `_TasksScreenState`.
    - Access the viewmodel using `Provider.of<TasksViewModel>(context)` or `Consumer<TasksViewModel>` in the widget tree.

### 2. **Listen to Changes with Consumer/Selector**

    - Use `Consumer<TasksViewModel>` or `Selector` to rebuild only the parts of the UI that depend on the task list.
    - This ensures the UI automatically updates whenever `notifyListeners()` is called in the viewmodel (e.g., after add, delete, or toggle completion).

### 3. **Update Data Mutations**

    - Ensure all data mutations (add, delete, toggle completion) go through the viewmodel and call `notifyListeners()`.
    - Remove manual `setState` calls in the screen; rely on Provider to trigger UI rebuilds.

### 4. **Update Widget Tree**

    - Pass the relevant task lists (`allTasks`, `todayTasks`, etc.) from the viewmodel via Provider to the UI widgets.
    - Update callbacks (e.g., add, delete, toggle) to use the viewmodel from Provider.

### 5. **Testing**

    - Test adding, deleting, and toggling tasks from all entry points (including other screens) and verify the UI updates immediately.
    - Test edge cases (e.g., deleting the last task, adding from a modal, etc.).

## **C. Example Refactor Steps**

1. In `main.dart` (or the relevant parent widget), wrap the app with `ChangeNotifierProvider(create: (_) => TasksViewModel())`.
2. In `TasksScreen`, remove the local `_viewModel` and use `Provider.of<TasksViewModel>(context)` or `Consumer`.
3. Replace all `setState` calls related to task data with viewmodel methods that call `notifyListeners()`.
4. Use `Consumer<TasksViewModel>` to rebuild the task list UI when the data changes.
5. Test thoroughly.

## **D. Benefits**

- The UI will always reflect the latest data, regardless of where changes occur.
- Reduces manual state management and potential for bugs.
- Follows best practices for scalable Flutter apps.

---
