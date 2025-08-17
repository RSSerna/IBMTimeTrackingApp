import 'package:flutter/material.dart';
import 'package:time_tracker/models/task.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key, required this.onAdd, this.task});
  final Function(Task) onAdd;
  final Task? task;

  @override
  AddTaskDialogState createState() => AddTaskDialogState();
}

class AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _controller.text = widget.task!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task != null ? 'Update Task' : 'Add Task'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Task Name',
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
            var newTask = Task(
                id: widget.task?.id ?? DateTime.now().toString(),
                name: _controller.text);
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
