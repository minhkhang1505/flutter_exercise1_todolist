import 'package:flutter/material.dart';
import 'search_suggestion_item.dart';
import 'search_tag_chip.dart';

class SearchSuggestionsWidget extends StatelessWidget {
  final Function(String) onSuggestionTap;
  final Function(String) onTagTap;

  const SearchSuggestionsWidget({
    super.key,
    required this.onSuggestionTap,
    required this.onTagTap,
  });

  @override
  Widget build(BuildContext context) {
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
        SearchSuggestionItem(
          icon: Icons.history,
          text: 'Research project',
          onTap: () => onSuggestionTap('Research project'),
        ),
        SearchSuggestionItem(
          icon: Icons.history,
          text: 'Meeting notes',
          onTap: () => onSuggestionTap('Meeting notes'),
        ),
        SearchSuggestionItem(
          icon: Icons.history,
          text: 'Shopping list',
          onTap: () => onSuggestionTap('Shopping list'),
        ),
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
            SearchTagChip(label: 'Work', onPressed: () => onTagTap('Work')),
            SearchTagChip(
              label: 'Personal',
              onPressed: () => onTagTap('Personal'),
            ),
            SearchTagChip(label: 'Urgent', onPressed: () => onTagTap('Urgent')),
            SearchTagChip(
              label: 'Important',
              onPressed: () => onTagTap('Important'),
            ),
          ],
        ),
      ],
    );
  }
}
