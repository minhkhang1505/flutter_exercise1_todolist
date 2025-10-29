import 'package:flutter/material.dart';

class ReminderTextWidget extends StatelessWidget {
  const ReminderTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "The reminder is set default for 10 minutes before the due date",
      style: TextStyle(color: Colors.grey),
      softWrap: true,
    );
  }
}
