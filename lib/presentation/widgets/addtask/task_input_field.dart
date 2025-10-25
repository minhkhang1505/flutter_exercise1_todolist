import 'package:flutter/material.dart';

/// Custom text input widget for task title and description
class TaskInputField extends StatelessWidget {
  final String hintText;
  final double fontSize;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int? maxLines;

  const TaskInputField({
    super.key,
    required this.hintText,
    required this.fontSize,
    required this.controller,
    this.keyboardType,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.withAlpha(250),
          fontSize: fontSize,
        ),
        border: InputBorder.none,
      ),
      keyboardType: keyboardType ?? TextInputType.multiline,
      maxLines: maxLines,
      style: TextStyle(fontSize: fontSize),
    );
  }
}
