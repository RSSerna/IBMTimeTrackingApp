import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/provider/time_entry_provider.dart';
import 'package:time_tracker/widgets/add_task_dialog_widget.dart';

class TaskManagementScreen extends StatelessWidget {
  const TaskManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Tasks"),
        backgroundColor:
            Colors.deepPurple, // Themed color similar to your inspirations
        foregroundColor: Colors.white,
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.task.length,
            itemBuilder: (context, index) {
              final tag = provider.task[index];
              return ListTile(
                title: Text(tag.name),
                // leading: IconButton(
                //   icon: const Icon(Icons.edit, color: Colors.red),
                //   onPressed: () {
                //     // Delete the tag
                //     provider.deleteTask(tag.id);
                //   },
                // ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Delete the tag
                    provider.deleteTask(tag.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTaskDialog(
              onAdd: (newTask) {
                Provider.of<TimeEntryProvider>(context, listen: false)
                    .addOrUpdateTask(newTask);
                Navigator.pop(
                    context); // Close the dialog after adding the new tag
              },
            ),
          );
        },
        tooltip: 'Add New Tag',
        child: const Icon(Icons.add),
      ),
    );
  }
}
