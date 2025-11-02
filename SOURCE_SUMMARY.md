## Source Summary: Architecture, Patterns, Maintainability, and Refactor Plan

This document reviews the current codebase structure, identifies strengths and issues, and proposes concrete improvements to make the project cleaner, easier to maintain, and ready to expand using modern Flutter practices.

---

## Architecture at a Glance

The project follows a layered Clean Architecture with MVVM in the presentation layer:

- Core (`lib/core/`)

  - `enums/`: Domain enums like `day_category.dart`, `priority_type.dart`
  - `formatters/`: `date_time_formatter.dart`, `priority_formatter.dart`
  - `services/`: `notification_service.dart`
  - `themes/`: `theme.dart`
  - `util.dart`: Small helpers
  - `utils/`: `task_filters.dart`

- Data (`lib/data/`)

  - `datasources/`: `task_local_datasource.dart`, `local/task_sqlite_datasource.dart`
  - `models/`: `task_model.dart` (mapping layer between persistence and domain)
  - `repositories/`: `repository_implement.dart` (implements domain repository)

- Domain (`lib/domain/`)

  - `entities/`: `task.dart`
  - `repositories/`: `repository.dart` (interfaces/contracts)
  - `usecases/`: `get_task_by_id_usecase.dart`, `get_upcomping_task_dealine_usecase.dart`, `search_tasks_usecase.dart`

- Presentation (`lib/presentation/`)
  - `models/`: `add_task_form_data.dart`
  - `screens/`: feature screens under `addtask/`, `search/`, `taskdetail/`, `tasks/`
  - `viewmodels/`: `add_task_viewmodel.dart`, `search_viewmodel.dart`, `task_detail_viewmodel.dart`, `tasks_viewmodel.dart`
  - `widgets/`: reusable widgets grouped by feature

Key takeaway: the layering is sensible and already aligns with Clean Architecture best practices. The presentation uses a ViewModel (MVVM) style, and the domain layer is properly isolated via interfaces.

---

## What’s Working Well

- Clear separation of concerns by layer (core/data/domain/presentation).
- Domain entities and repository interfaces allow swapping data sources (e.g., local memory vs SQLite).
- Use cases exist for common business operations (fetch by id, search, upcoming deadline).
- Presentation is organized by feature with dedicated widgets and viewmodels.
- Theming and formatters are centralized under `core/`.

---

## Findings and Issues (from quick static analysis and structure review)

Structural/naming

- Typos in use case filename: `get_upcomping_task_dealine_usecase.dart` (should be `get_upcoming_task_deadline_usecase.dart`). Typos harm discoverability and IDE navigation.
- The previous doc referenced `providers/` but the actual structure uses `viewmodels/` (correct and consistent with MVVM).

Data layer

- SQLite data source exists (`data/datasources/local/task_sqlite_datasource.dart`), but analyzer reports missing dependencies for `path` and `path_provider` in `pubspec.yaml`.

Notifications

- `core/services/notification_service.dart` imports `timezone` and `flutter_local_notifications` symbols that are either unused or no longer exported (e.g., `UILocalNotificationDateInterpretation`). The analyzer flags:
  - Unused or invalid `show` member from `flutter_local_notifications`.
  - Missing `timezone` dependency in `pubspec.yaml`.

UI/state

- Analyzer flags `use_build_context_synchronously` in `tasks_screen.dart` and `task_detail_screen.dart` (accessing `context` after `await`).
- Local variable `_viewModel` in `tasks_screen.dart` suggests manual state wiring; prefer DI/Provider rather than local singleton/field.

Theming and deprecations

- `MaterialStateProperty` and `ThemeData.colorScheme.background` are deprecated in the current Flutter version; use `WidgetStateProperty` and `colorScheme.surface`.

Quality gates snapshot

- Static analysis: FAIL (warnings and errors present; see “Quality gates” below).

---

## Business Logic Review (at a high level)

Based on filenames and layering, the business logic direction is correct: domain use cases orchestrate repositories; repositories abstract data sources; entities are separate from persistence models. Without diving into every function, here are likely correctness hotspots to validate:

- Time and deadlines

  - Convert and store times consistently (UTC vs local). Check notification scheduling with time zones (requires `timezone` setup if using zoned scheduling).
  - Edge cases: past deadlines, daylight saving changes, 24h wrap-around.

- Task states and integrity

  - Unique IDs (consider using UUIDs). Ensure updates/deletes target the correct row.
  - Validation: title required, deadline not before start, priority within enum range.

- Search

  - Case- and diacritic-insensitive search; consider indexed fields for large data sets.
  - Define whether search includes description, tags, or only titles.

- Persistence
  - Migrations when schema changes; wrap multi-step writes in transactions.
  - Map domain <-> model explicitly; avoid leaking data-layer types into domain.

If any of the above is missing, address in the refactor plan below.

---

## Modernization and Maintainability Upgrades

State management and DI

- Move to a central dependency injection approach:
  - Option A: Provider + `get_it` for DI (lightweight, familiar).
  - Option B: Riverpod for both state and DI (testable, immutable by default).
- Expose ViewModel/application state as immutable models and emit via notifiers/providers; avoid mutable fields scattered across widgets.

Domain/use case ergonomics

- Standardize use case results to `Result<T, Failure>` or `Either<Failure, T>` pattern (sealed class) for explicit error handling.
- Consider code generation for data classes:
  - `freezed` for immutable models/unions.
  - `json_serializable` for model <-> map.

Data/persistence

- Keep `TaskModel` as the only type that knows about SQLite (table/column names).
- Consider adopting `drift` if you want type-safe queries and reactive streams; otherwise ensure `sqflite` access is isolated in one place.

Navigation

- Consider `go_router` for typed, declarative navigation and deep links to specific tasks.

Theming and design system

- Migrate deprecated fields: `colorScheme.background` -> `colorScheme.surface`.
- Avoid deprecated `MaterialStateProperty` -> use `WidgetStateProperty`.

Testing

- Unit tests: use cases, repository implementations, mappers (entity <-> model).
- Widget tests: critical screens (tasks list, add/edit, search) + golden tests for stable UI.
- Integration tests: persistence (CRUD), notification scheduling (where feasible).

Tooling and quality

- Ensure `analysis_options.yaml` uses `package:flutter_lints/flutter.yaml` and enable helpful lints (e.g., `use_build_context_synchronously`, `prefer_final_locals`).
- Add CI to run `flutter analyze`, `flutter test`, and format checks on PRs.

---

## Concrete Refactor Plan (phased, low-risk)

Phase 1 — Safety and hygiene

1. Fix typos and naming consistency

   - Rename `lib/domain/usecases/get_upcomping_task_dealine_usecase.dart` → `get_upcoming_task_deadline_usecase.dart` and update imports.

2. Address analyzer errors/warnings

   - Add missing dependencies to `pubspec.yaml`: `path`, `path_provider`, `timezone` (if used). Remove unused `flutter_local_notifications` exports from `show` list and update API usage to current names.
   - Replace deprecated `MaterialStateProperty` and `colorScheme.background`.
   - Fix `use_build_context_synchronously` by checking `mounted` before using `context` after `await`.

3. Tighten state management wiring
   - Provide `TasksViewModel`/others via DI at the app root; remove local `_viewModel` fields in screens. Prefer `Consumer`/`Selector`.

Phase 2 — Structure and contracts 4) Introduce a lightweight Result pattern - Wrap use case outputs in `Result<T, Failure>` (via `freezed`). Centralize failures (e.g., `ValidationFailure`, `NotFoundFailure`).

5. Codify mapping boundaries

   - Keep `TaskEntity` pure; add `TaskModel.fromMap/toMap`; ensure the repository is the only layer that knows the model.

6. Persistence improvements
   - Confirm indexes (e.g., on `due_date`, `title` for search). Add simple migrations and a schema version.

Phase 3 — UX and capabilities 7) Notifications stability - Configure `timezone` initialization; migrate to the latest `flutter_local_notifications` `zonedSchedule` API and remove references to `UILocalNotificationDateInterpretation` (no longer exported). - Add a simple settings toggle to enable/disable reminders.

8. Navigation and deep links
   - Move to `go_router` if routing complexity grows (optional but recommended).

Phase 4 — Tests and CI 9) Tests - Add unit tests for use cases and repository; widget tests for screens; a couple of goldens.

10. CI and formatting
    - GitHub Actions: run `flutter analyze`, `flutter test`, `dart format --set-exit-if-changed .`.

---

## Quality gates: current status

- Build/Analyze: FAIL (based on analyzer output)
  - Deprecations in `core/themes/theme.dart` and `widgets/taskdetail/danger_button.dart`.
  - `use_build_context_synchronously` in `presentation/screens/tasks/tasks_screen.dart` and `presentation/screens/taskdetail/task_detail_screen.dart`.
  - Missing `path`, `path_provider`, `timezone` deps.
  - Invalid/unused import and an obsolete symbol in `core/services/notification_service.dart`.

Target after Phase 1: PASS (no analyzer errors; only informational lints allowed).

---

## How to expand safely

- Feature-first modules: if the app grows, consider grouping by feature with internal sublayers (domain/data/presentation) while keeping shared domain entities in `lib/domain/`.
- Add tags and filters: create `TagEntity`, many-to-many mapping table `task_tags`, a `Filter` value object for complex queries.
- Cloud sync: introduce a remote datasource (`data/datasources/remote/…`), then a sync orchestrator use case.

---

## Quick contracts (recommended)

- Use case inputs/outputs

  - Input: small value objects (e.g., `TaskId`, `SearchQuery`).
  - Output: `Result<T, Failure>` where `T` is entity or list of entities.

- Error modes

  - Validation errors (bad dates, empty title), not-found, IO/db errors, permission (notifications).

- Success criteria
  - All public APIs are null-safe, deterministic, and side-effect free (except scheduled effects like notifications/persistence).

---

## Actionable checklist (TL;DR)

- [ ] Rename `get_upcomping_task_dealine_usecase.dart` → `get_upcoming_task_deadline_usecase.dart`.
- [ ] Add missing deps to `pubspec.yaml`: `path`, `path_provider`, `timezone` (if zoned scheduling is used).
- [ ] Update `notification_service.dart` to latest plugin API; remove obsolete `UILocalNotificationDateInterpretation` symbol and unused imports.
- [ ] Fix `use_build_context_synchronously` with `if (!mounted) return;` guards.
- [ ] Replace deprecated `MaterialStateProperty` → `WidgetStateProperty`; `colorScheme.background` → `colorScheme.surface`.
- [ ] Provide viewmodels via DI/Provider at app root; remove local `_viewModel` instances in screens.
- [ ] Add tests for use cases (happy path + edge cases) and task model mapping.

---

## References

- Flutter lints: `package:flutter_lints/flutter.yaml`
- State mgmt: Provider, Riverpod, or Bloc (pick one and standardize)
- Persistence: `sqflite`, `drift`
- Notifications: `flutter_local_notifications`, `timezone`
- Navigation: `go_router`

---

Completion summary

- Assessed structure and patterns; corrected previous doc inaccuracies to reflect the actual repo.
- Listed concrete findings from static analysis and provided a phased plan to reach green quality gates and modernize safely.
- Focused on maintainability, clean boundaries, and expansion readiness.

---

> Legacy section below (kept for reference). The authoritative, updated guidance is in the sections above.

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
