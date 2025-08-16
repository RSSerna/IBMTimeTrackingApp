import 'package:flutter/material.dart';
import 'package:time_tracker/models/task.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onAdd;

  const AddTaskDialog({super.key, required this.onAdd});

  @override
  AddTaskDialogState createState() => AddTaskDialogState();
}

class AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Tag'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Tag Name',
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            var newTask =
                Task(id: DateTime.now().toString(), name: _controller.text);
            widget.onAdd(newTask);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
