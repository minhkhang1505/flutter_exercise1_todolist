import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/core/services/notification_service.dart';
import 'package:flutter_exercise1_todolist/data/datasources/task_local_datasource.dart';
import 'package:flutter_exercise1_todolist/data/repositories/repository_implement.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';
import 'package:flutter_exercise1_todolist/core/enums/priority_type.dart';
import '../models/add_task_form_data.dart';

class AddTaskViewmodel extends ChangeNotifier {
  final TaskRepositoryImpl _repository = TaskRepositoryImpl();

  List<TaskEntity> _tasks = [];

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Add a new task
  Future<bool> addNewTask(AddTaskFormData formData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      //debug
      debugPrint("🚀 [START] Adding new task...");
      debugPrint("📋 Raw formData: ${formData.toString()}");

      // Convert form data to TaskEntity
      final taskEntity = _convertFormDataToEntity(formData);

      //debug
      debugPrint("✅ [CONVERTED] TaskEntity created:");
      debugPrint("   🆔 id: ${taskEntity.id}");
      debugPrint("   🏷️ title: ${taskEntity.title}");
      debugPrint("   🗒️ description: ${taskEntity.description}");
      debugPrint("   📅 dueDate: ${taskEntity.dueDate}");
      debugPrint("   ⏰ deadline: ${taskEntity.deadline}");
      debugPrint("   ✅ completed: ${taskEntity.isCompleted}");

      // Add task through data source
      await _repository.addTask(taskEntity);
      //debug
      debugPrint("💾 [DB] Task saved successfully");

      // add reminder 10 minutes before deadline if dueDate and dueTime are set
      if (taskEntity.dueDate != null && taskEntity.deadline != null) {
        final deadline = DateTime(
          taskEntity.dueDate!.year,
          taskEntity.dueDate!.month,
          taskEntity.dueDate!.day,
          taskEntity.deadline!.hour,
          taskEntity.deadline!.minute,
        );

        //debug
        final scheduledTime = deadline.subtract(const Duration(minutes: 10));
        debugPrint("⏳ [NOTIFICATION] Scheduling 10 min before deadline...");
        debugPrint("   🕒 Deadline: $deadline");
        debugPrint("   📆 Scheduled Time: $scheduledTime");

        // covert to 32 bit interger suitable for notification ID
        final notificationId = taskEntity.id.hashCode & 0x7FFFFFFF;
        debugPrint("   🆔 Notification ID: $notificationId");

        await NotificationService().scheduleDeadlineNotification(
          id: notificationId,
          title: taskEntity.title,
          description: taskEntity.description,
          deadline: deadline,
        );

        //debug
        debugPrint("🔔 [NOTIFICATION] Scheduled successfully!");
      } else {
        debugPrint("⚠️ [NOTIFICATION] Skipped (dueDate or deadline is null)");
      }

      //refresh local task list
      _tasks = await _repository.getTasks();

      //debug
      debugPrint("📂 [DB] Current tasks after add:");
      for (var task in _tasks) {
        debugPrint(
          "   📝 ${task.id} | ${task.title} | ${task.dueDate} | ${task.deadline}",
        );
      }

      for (var task in _tasks) {
        debugPrint("📝 Task: ${task.id} - ${task.title}");
      }

      _isLoading = false;
      notifyListeners();

      //debug
      debugPrint("✅ [SUCCESS] Task added successfully\n");

      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Convert AddTaskFormData to TaskEntity
  TaskEntity _convertFormDataToEntity(AddTaskFormData formData) {
    // Generate unique ID (using timestamp for simplicity)
    final id = DateTime.now().millisecondsSinceEpoch;

    // Convert priority string to enum
    PriorityType? priorityType;
    if (formData.priority != null) {
      priorityType = PriorityType.values.firstWhere(
        (type) => type.name == formData.priority,
        orElse: () => PriorityType.low,
      );
    }

    return TaskEntity(
      id: id,
      title: formData.title,
      description: formData.description,
      dueDate: formData.dueDate,
      startDate: DateTime.now(), // Set start date to now
      deadline: formData.dueTime, // Use dueTime as deadline
      isCompleted: false,
      priorityType: priorityType,
    );
  }

  /// Clear any error state
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
