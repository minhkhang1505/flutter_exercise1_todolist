import 'package:flutter/material.dart';

class SearchResultsWidget extends StatelessWidget {
  final String searchQuery;

  const SearchResultsWidget({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
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

    // TODO: Implement actual search results
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text('Search results will appear here', textAlign: TextAlign.center),
      ],
    );
  }
}
