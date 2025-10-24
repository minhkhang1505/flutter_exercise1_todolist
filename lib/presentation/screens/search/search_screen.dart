import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

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
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: _isSearchFocused ? null : _buildAppBar(colorScheme),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(colorScheme),
            Expanded(
              child: _isSearchFocused
                  ? _buildSearchSuggestions()
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the app bar (hidden when search is focused)
  PreferredSizeWidget _buildAppBar(ColorScheme colorScheme) {
    return AppBar(
      title: const Text(
        'Search',
        style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
      ),
      backgroundColor: colorScheme.surface,
    );
  }

  /// Build the search bar with focus handling
  Widget _buildSearchBar(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          if (_isSearchFocused)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _searchFocusNode.unfocus();
                _clearSearch();
              },
            ),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              autofocus: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: colorScheme.primary.withAlpha(20),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                hintText: 'Search tasks...',
                prefixIcon: Icon(
                  Icons.search,
                  color: colorScheme.onSurfaceVariant,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {}); // Rebuild to show/hide clear button
                // TODO: Implement search logic
              },
            ),
          ),
          if (_isSearchFocused)
            IconButton(
              icon: const Icon(Icons.tune),
              onPressed: () {
                // TODO: Show filter options
              },
            ),
        ],
      ),
    );
  }

  /// Build search suggestions (shown when focused but no/little input)
  Widget _buildSearchSuggestions() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.refresh),
            ],
          ),
        ),
        _buildSuggestionItem(Icons.history, 'Research project'),
        _buildSuggestionItem(Icons.history, 'Meeting notes'),
        _buildSuggestionItem(Icons.history, 'Shopping list'),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Popular Tags',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTagChip('Work'),
            _buildTagChip('Personal'),
            _buildTagChip('Urgent'),
            _buildTagChip('Important'),
          ],
        ),
      ],
    );
  }

  /// Build a single suggestion item
  Widget _buildSuggestionItem(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(text),
      trailing: const Icon(Icons.north_west, size: 16),
      onTap: () {
        _searchController.text = text;
        setState(() {});
      },
    );
  }

  /// Build a tag chip
  Widget _buildTagChip(String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        _searchController.text = label;
        setState(() {});
      },
    );
  }

  /// Build search results (shown when not focused)
  Widget _buildSearchResults() {
    if (_searchController.text.isEmpty) {
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

    // TODO: Implement actual search results
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text('Search results will appear here', textAlign: TextAlign.center),
      ],
    );
  }
}
