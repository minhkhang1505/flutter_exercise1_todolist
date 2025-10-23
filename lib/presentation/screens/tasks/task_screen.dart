import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/core/utils/task_filters.dart';
import 'package:flutter_exercise1_todolist/data/datasources/task_local_datasource.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';
import 'package:flutter_exercise1_todolist/presentation/screens/tasks/widgets/custom_tab_bar.dart';
import 'package:flutter_exercise1_todolist/presentation/screens/tasks/widgets/task_list_view.dart';

/// Main screen for displaying and managing tasks
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Task> _tasks = [];

  // Map to track completion status of each task by ID
  final Map<int, bool> _completedTasks = {};

  // Data source instance
  final _dataSource = TaskLocalDataSource();
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

  /// Load tasks from data source
  Future<void> _loadTasks() async {
    final tasks = await _dataSource.getTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  /// Toggle task completion status
  void _toggleTaskCompletion(int taskId, bool? value) {
    setState(() {
      _completedTasks[taskId] = value ?? false;
    });
  }

  /// Get filtered tasks based on current tab
  List<Task> _getFilteredTasks(int tabIndex) {
    if (_tasks.isEmpty) return [];

    switch (tabIndex) {
      case 0: // All tasks
        return _tasks;
      case 1: // Today tasks
        return TaskFilters.getTodayTasks(_tasks);
      case 2: // Upcoming tasks
        return TaskFilters.getUpcomingTasks(_tasks);
      default:
        return _tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Tasks',
        style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
        child: Column(
          children: [
            CustomTabBar(
              controller: _tabController,
              tabs: const ['All', 'Today', 'Upcoming'],
            ),
            Expanded(child: _buildTabBarView()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: List.generate(3, (index) {
        final filteredTasks = _getFilteredTasks(index);
        return TaskListView(
          tasks: filteredTasks,
          completedTasks: _completedTasks,
          onTaskToggle: _toggleTaskCompletion,
        );
      }),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      onPressed: _onAddTask,
      tooltip: 'Add Task',
      child: const Icon(Icons.add),
    );
  }

  /// Handle add task action
  void _onAddTask() {
    // TODO: Navigate to add task screen or show dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add task functionality coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
