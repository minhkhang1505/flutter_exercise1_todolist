import 'package:flutter/material.dart';

class SearchSuggestionItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const SearchSuggestionItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(text),
      trailing: const Icon(Icons.north_west, size: 16),
      onTap: onTap,
    );
  }
}
