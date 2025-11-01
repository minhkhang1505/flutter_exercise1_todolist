import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/presentation/screens/taskdetail/task_detail_screen.dart';
import '../../viewmodels/search_viewmodel.dart' as search_ctrl;
import '../../widgets/search/search_app_bar.dart';
import '../../widgets/search/search_bar_widget.dart';
import '../../widgets/search/search_suggestions_widget.dart';
import '../../widgets/search/search_results_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<search_ctrl.SearchViewModel>().clearSearch();
    setState(() {});
  }

  void _handleSuggestionTap(String text) {
    _searchController.text = text;
    _performSearch(text);
  }

  void _handleBackPress() {
    _searchFocusNode.unfocus();
    _clearSearch();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      context.read<search_ctrl.SearchViewModel>().clearSearch();
      setState(() {});
      return;
    }
    await context.read<search_ctrl.SearchViewModel>().searchTasks(query);
    setState(() {});
  }

  void _onTaskClicked(int taskId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(taskId: taskId)),
    ).then((value) {
      if (value != null) {
        // Optionally refresh search results or perform other actions
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<search_ctrl.SearchViewModel>();
    final hasQuery = _searchController.text.trim().isNotEmpty;
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
              onChanged: _onSearchChanged,
            ),
            Expanded(
              child: hasQuery
                  ? SearchResultsWidget(
                      searchQuery: _searchController.text,
                      searchResults: viewModel.searchResults,
                      isLoading: viewModel.isLoading,
                      onTaskClicked: _onTaskClicked,
                    )
                  : (_isSearchFocused
                        ? SearchSuggestionsWidget(
                            onSuggestionTap: _handleSuggestionTap,
                            onTagTap: _handleSuggestionTap,
                          )
                        : SearchResultsWidget(
                            searchQuery: _searchController.text,
                            searchResults: viewModel.searchResults,
                            isLoading: viewModel.isLoading,
                            onTaskClicked: _onTaskClicked,
                          )),
            ),
          ],
        ),
      ),
    );
  }
}
