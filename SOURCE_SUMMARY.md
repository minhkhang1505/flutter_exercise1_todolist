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
- All task data is currently stored in-memory via a singleton `TaskLocalDataSource`.
- Data is lost on app restart; no persistent storage is used yet.

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
| File/Folder                                 | Purpose                                    |
|---------------------------------------------|--------------------------------------------|
| `pubspec.yaml`                              | Add SQLite dependencies                    |
| `lib/data/datasources/task_sqlite_datasource.dart` | SQLite CRUD logic for tasks                |
| `lib/data/repositories/repository_implement.dart`  | Use SQLite data source                     |
| `lib/domain/entities/task.dart`              | Ensure entity is SQLite-compatible          |
| `lib/presentation/viewmodels/`              | Update to use repository abstraction        |
| `test/`                                     | Add tests for SQLite integration            |

---

## **References**
- [sqflite package](https://pub.dev/packages/sqflite)
- [drift package](https://pub.dev/packages/drift)
- [Flutter: Persist data with SQLite](https://docs.flutter.dev/cookbook/persistence/sqlite)

---

**This plan will enable robust, persistent offline storage for all tasks, while keeping the codebase clean, testable, and maintainable.**
