import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: colorScheme.surface,
      ),
      body: const Center(child: Text('Search Screen Content')),
    );
  }
}
