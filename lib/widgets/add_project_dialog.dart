import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/project.dart';
import 'package:time_tracker/provider/time_entry_provider.dart';

class AddProjectDialog extends StatefulWidget {
  const AddProjectDialog({
    super.key,
    required this.onAdd,
  });

  final Function(Project) onAdd;
  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Category'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(labelText: 'Category Name'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final project = Project(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: _controller.text,
            );
            Provider.of<TimeEntryProvider>(context, listen: false)
                .addOrUpdateProject(project);
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
