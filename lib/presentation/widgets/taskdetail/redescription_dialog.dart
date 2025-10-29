import 'package:flutter/material.dart';

class RedescriptionDialog extends StatefulWidget {
  final String initialDescription;
  final Function(String) onSave;

  const RedescriptionDialog({
    super.key,
    required this.initialDescription,
    required this.onSave,
  });

  @override
  State<RedescriptionDialog> createState() => _RedescriptionDialogState();
}

class _RedescriptionDialogState extends State<RedescriptionDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Redescription Task'),
      content: TextField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: null,
        expands: false,
        controller: _controller,
        decoration: InputDecoration(hintText: "Enter new task description"),
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
