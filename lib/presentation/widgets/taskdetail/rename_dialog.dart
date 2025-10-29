import 'package:flutter/material.dart';

class RenameDialog extends StatefulWidget {
  final String initialTitle;
  final Function(String) onSave;

  const RenameDialog({
    super.key,
    required this.initialTitle,
    required this.onSave,
  });

  @override
  State<RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rename Task'),
      content: TextField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: null,
        expands: false,
        controller: _controller,
        decoration: InputDecoration(hintText: "Enter new task title"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onSave(_controller.text);
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
