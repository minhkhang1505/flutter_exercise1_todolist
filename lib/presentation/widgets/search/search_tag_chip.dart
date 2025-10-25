import 'package:flutter/material.dart';

class SearchTagChip extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const SearchTagChip({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text(label), onPressed: onPressed);
  }
}
