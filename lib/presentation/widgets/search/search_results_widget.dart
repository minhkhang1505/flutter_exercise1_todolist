import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';
import '../tasks/task_item.dart';

class SearchResultsWidget extends StatelessWidget {
  final String searchQuery;
  final List<TaskEntity> searchResults;
  final bool isLoading;

  const SearchResultsWidget({
    super.key,
    required this.searchQuery,
    this.searchResults = const [],
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Show empty state when no query
    if (searchQuery.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey.withAlpha(128)),
            const SizedBox(height: 16),
            Text(
              'Search for tasks',
              style: TextStyle(fontSize: 18, color: Colors.grey.withAlpha(200)),
            ),
          ],
        ),
      );
    }

    // Show loading indicator
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show no results found
    if (searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.withAlpha(128)),
            const SizedBox(height: 16),
            Text(
              'No tasks found for "$searchQuery"',
              style: TextStyle(fontSize: 18, color: Colors.grey.withAlpha(200)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Show search results
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final task = searchResults[index];
        return TaskItem(
          task: task,
          isCompleted: task.isCompleted,
          onChanged: (value) {
            // TODO: Handle task completion toggle
          },
        );
      },
    );
  }
}
