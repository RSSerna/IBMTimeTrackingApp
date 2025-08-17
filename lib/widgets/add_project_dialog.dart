import 'package:flutter/material.dart';
import 'package:time_tracker/models/project.dart';

class AddProjectDialog extends StatefulWidget {
  const AddProjectDialog({
    super.key,
    required this.onAdd,
    this.project,
  });

  final Function(Project) onAdd;
  final Project? project;

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.project != null) {
      _controller.text = widget.project!.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.project != null ? 'Update Project' : 'Add Project'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(labelText: 'Project Name'),
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
              id: widget.project?.id ??
                  DateTime.now().millisecondsSinceEpoch.toString(),
              name: _controller.text,
            );
            widget.onAdd(project);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
