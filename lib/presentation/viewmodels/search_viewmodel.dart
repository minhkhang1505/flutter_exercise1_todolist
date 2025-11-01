import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';
import 'package:flutter_exercise1_todolist/domain/usecases/search_tasks_usecase.dart';

/// Controller for search functionality
/// Uses SearchTasksUseCase following Clean Architecture
class SearchViewModel extends ChangeNotifier {
  final SearchTasksUseCase _searchTasksUseCase;

  List<TaskEntity> _searchResults = [];
  bool _isLoading = false;
  String _lastQuery = '';

  SearchViewModel({required SearchTasksUseCase searchTasksUseCase})
    : _searchTasksUseCase = searchTasksUseCase;

  /// Get current search results
  List<TaskEntity> get searchResults => _searchResults;

  /// Get loading state
  bool get isLoading => _isLoading;

  /// Get last search query
  String get lastQuery => _lastQuery;

  /// Search tasks by query
  Future<void> searchTasks(String query) async {
    _lastQuery = query;
    _isLoading = true;

    try {
      _searchResults = await _searchTasksUseCase.execute(query);
    } catch (e) {
      _searchResults = [];
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  /// Clear search results
  void clearSearch() {
    _searchResults = [];
    _lastQuery = '';
  }
}
