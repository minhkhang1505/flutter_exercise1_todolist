import 'package:flutter/material.dart';
import '../addtask/add_new_task_screen.dart';
import '../../utils/controllers/tasks_controller.dart';
import '../../widgets/tasks/tasks_app_bar.dart';
import '../../widgets/tasks/tasks_tab_section.dart';
import '../../widgets/tasks/tasks_floating_button.dart';

/// Main screen for displaying and managing tasks
/// Follows clean architecture with separated concerns
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _controller = TasksController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Load tasks from controller
  Future<void> _loadTasks() async {
    await _controller.loadTasks();
    if (mounted) setState(() {});
  }

  /// Toggle task completion status
  void _toggleTaskCompletion(int taskId, bool? value) {
    setState(() {
      _controller.toggleTaskCompletion(taskId, value);
    });
  }

  /// Handle add task action
  void _onAddTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const AddNewTaskScreen(),
    ).then((result) {
      // Reload tasks after adding new task
      if (result != null) {
        _loadTasks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TasksAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
          child: TasksTabSection(
            tabController: _tabController,
            allTasks: _controller.allTasks,
            todayTasks: _controller.todayTasks,
            upcomingTasks: _controller.upcomingTasks,
            completedTasks: _controller.completedTasks,
            onTaskToggle: _toggleTaskCompletion,
          ),
        ),
      ),
      floatingActionButton: TasksFloatingButton(onPressed: _onAddTask),
    );
  }
}
