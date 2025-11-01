import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/core/enums/priority_type.dart';

class PriorityWidget extends StatelessWidget {
  const PriorityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surfaceContainerLow,
      ),
      child: DropDownMenuPriority(
        initialValue: PriorityType.medium,
        onChanged: (priority) {
          // Handle priority change
        },
      ),
    );
  }
}

class DropDownMenuPriority extends StatefulWidget {
  final PriorityType? initialValue;
  final ValueChanged<PriorityType?>? onChanged;

  const DropDownMenuPriority({super.key, this.initialValue, this.onChanged});

  @override
  State<DropDownMenuPriority> createState() => _DropDownMenuPriorityState();
}

class _DropDownMenuPriorityState extends State<DropDownMenuPriority> {
  PriorityType? selectedPriority;

  @override
  void initState() {
    super.initState();
    selectedPriority = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Priority:',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<PriorityType>(
          value: selectedPriority,
          hint: const Text('Select Priority'),
          items: PriorityType.values
              .map(
                (priority) => DropdownMenuItem(
                  value: priority,
                  child: Row(
                    children: [
                      Icon(Icons.bookmark, color: priority.color, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        priority.name,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (PriorityType? priority) {
            setState(() {
              selectedPriority = priority;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(priority);
            }
          },
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          dropdownColor: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
          underline: Container(height: 0, color: colorScheme.primary),
        ),
      ],
    );
  }
}
