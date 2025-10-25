import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/data/repositories/repository_implement.dart';
import 'package:flutter_exercise1_todolist/domain/usecases/search_tasks_usecase.dart';
import 'package:flutter_exercise1_todolist/domain/entities/task.dart';
import '../../utils/controllers/search_controller.dart' as search_ctrl;
import '../../widgets/search/search_app_bar.dart';
import '../../widgets/search/search_bar_widget.dart';
import '../../widgets/search/search_suggestions_widget.dart';
import '../../widgets/search/search_results_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;
  late search_ctrl.SearchController _controller;
  List<TaskEntity> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);

    // Initialize search controller with use case
    final repository = TaskRepositoryImpl();
    _controller = search_ctrl.SearchController(
      searchTasksUseCase: SearchTasksUseCase(repository),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _controller.clearSearch();
    setState(() {
      _searchResults = [];
    });
  }

  void _handleSuggestionTap(String text) {
    _searchController.text = text;
    _performSearch(text);
  }

  void _handleBackPress() {
    _searchFocusNode.unfocus();
    _clearSearch();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    await _controller.searchTasks(query);
    setState(() {
      _searchResults = _controller.searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearchFocused ? null : const SearchAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            SearchBarWidget(
              controller: _searchController,
              focusNode: _searchFocusNode,
              isSearchFocused: _isSearchFocused,
              onClear: _clearSearch,
              onBack: _handleBackPress,
              onChanged: (value) {
                _performSearch(value);
              },
            ),
            Expanded(
              child: _isSearchFocused
                  ? SearchSuggestionsWidget(
                      onSuggestionTap: _handleSuggestionTap,
                      onTagTap: _handleSuggestionTap,
                    )
                  : SearchResultsWidget(
                      searchQuery: _searchController.text,
                      searchResults: _searchResults,
                      isLoading: _controller.isLoading,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
