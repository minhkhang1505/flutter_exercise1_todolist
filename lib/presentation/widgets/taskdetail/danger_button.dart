import 'package:flutter/material.dart';

/// A reusable button for destructive actions (e.g., delete)
class DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  const DangerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null
          ? Icon(icon, color: colorScheme.onError)
          : const SizedBox.shrink(),
      label: Text(label, style: TextStyle(color: colorScheme.onError)),
      style:
          ElevatedButton.styleFrom(
            backgroundColor: colorScheme.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 0,
          ).copyWith(
            // Hide icon space if no icon
            iconColor: icon == null
                ? MaterialStateProperty.all(Colors.transparent)
                : null,
          ),
    );
  }
}
