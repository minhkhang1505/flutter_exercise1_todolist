import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';
import 'custom_tab_bar.dart';
import 'task_list_view.dart';

/// Widget containing the tab bar and tab views for task filtering
class TasksTabSection extends StatelessWidget {
  final TabController tabController;
  final List<TaskEntity> allTasks;
  final List<TaskEntity> todayTasks;
  final List<TaskEntity> upcomingTasks;
  final Map<int, bool> completedTasks;
  final Function(int, bool?) onTaskToggle;

  const TasksTabSection({
    super.key,
    required this.tabController,
    required this.allTasks,
    required this.todayTasks,
    required this.upcomingTasks,
    required this.completedTasks,
    required this.onTaskToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTabBar(
          controller: tabController,
          tabs: const ['All', 'Today', 'Upcoming'],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              TaskListView(
                tasks: allTasks,
                completedTasks: completedTasks,
                onTaskToggle: onTaskToggle,
              ),
              TaskListView(
                tasks: todayTasks,
                completedTasks: completedTasks,
                onTaskToggle: onTaskToggle,
              ),
              TaskListView(
                tasks: upcomingTasks,
                completedTasks: completedTasks,
                onTaskToggle: onTaskToggle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
