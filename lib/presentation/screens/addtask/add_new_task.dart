import 'package:flutter/material.dart';

class AddNewTaskScreen extends StatelessWidget {
  const AddNewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceBright,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "e.g., Research Artificial Intelligence",
                  hintStyle: TextStyle(
                    color: Colors.grey.withAlpha(250),
                    fontSize: 20,
                  ),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(
                    color: Colors.grey.withAlpha(250),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //date picker
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.surface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: colorScheme.primary.withAlpha(100),
                            width: 1,
                          ),
                        ),
                      ),
                      onPressed: () {
                        // Handle save action
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.calendar_month),
                          SizedBox(width: 8),
                          Text('Date'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // priority picker
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.surface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),

                          side: BorderSide(
                            color: colorScheme.primary.withAlpha(100),
                            width: 1,
                          ),
                        ),
                      ),

                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.bookmark),
                          SizedBox(width: 8),
                          Text('Priority'),
                        ],
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: CircleBorder(
                      side: BorderSide(
                        color: colorScheme.primary.withAlpha(100),
                        width: 1,
                      ),
                    ),
                  ),
                  label: Icon(
                    Icons.arrow_upward,
                    size: 24,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
