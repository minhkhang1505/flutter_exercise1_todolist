import 'package:flutter/material.dart';

class PriorityWidget extends StatelessWidget {
  const PriorityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.bookmark, color: colorScheme.primary),
        Text("Priority"),
      ],
    );
  }
}
