import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/presentation/screens/taskdetail/task_detail_screen.dart';
import '../addtask/add_new_task_screen.dart';
import '../../viewmodels/tasks_viewmodel.dart';
import '../../widgets/tasks/tasks_app_bar.dart';
import '../../widgets/tasks/tasks_tab_section.dart';
import '../../widgets/tasks/tasks_floating_button.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTaskClicked(int taskId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(taskId: taskId)),
    ).then((value) async {
      if (value == 'deleted' || value == 'updated') {
        // Reload tasks after delete or update
        await context.read<TasksViewModel>().loadTasks();
      }
    });
  }

  void _toggleTaskCompletion(int taskId, bool? value) {
    final viewModel = context.read<TasksViewModel>();
    final prevValue = viewModel.completedTasks[taskId] ?? false;
    viewModel.toggleTaskCompletion(taskId, value);
    // Show snackbar only when marking as complete
    if ((value ?? false) && !prevValue) {
      bool undoPressed = false;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      final snackBar = SnackBar(
        content: const Text('Task marked as complete'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            undoPressed = true;
            viewModel.toggleTaskCompletion(taskId, false);
          },
        ),
        duration: const Duration(seconds: 3),
      );
      final controller = ScaffoldMessenger.of(context).showSnackBar(snackBar);
      controller.closed.then((reason) async {
        if (!undoPressed) {
          await viewModel.deleteTask(taskId);
        }
      });
    }
  }

  void _onAddTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const AddNewTaskScreen(),
    ).then((result) async {
      if (result != null) {
        // Reload tasks after adding new task
        await context.read<TasksViewModel>().loadTasks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _viewModel = context.watch<TasksViewModel>();
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
