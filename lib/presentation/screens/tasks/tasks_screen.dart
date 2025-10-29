import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/presentation/screens/taskdetail/task_detail_screen.dart';
import '../addtask/add_new_task_screen.dart';
import '../../viewmodels/tasks_viewmodel.dart';
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
  final _viewModel = TasksViewModel();

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
    await _viewModel.loadTasks();
    if (mounted) setState(() {});
  }

  void _onTaskClicked(int taskId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(taskId: taskId)),
    ).then((value) {
      if (value != null) {
        _loadTasks();
      }
    });
  }

  /// Toggle task completion status
  void _toggleTaskCompletion(int taskId, bool? value) {
    setState(() {
      _viewModel.toggleTaskCompletion(taskId, value);
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
            allTasks: _viewModel.allTasks,
            todayTasks: _viewModel.todayTasks,
            upcomingTasks: _viewModel.upcomingTasks,
            completedTasks: _viewModel.completedTasks,
            onTaskToggle: _toggleTaskCompletion,
            onTaskClicked: _onTaskClicked,
          ),
        ),
      ),
      floatingActionButton: TasksFloatingButton(onPressed: _onAddTask),
    );
  }
}
