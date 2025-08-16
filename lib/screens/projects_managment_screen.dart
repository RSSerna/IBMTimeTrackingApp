import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/provider/time_entry_provider.dart';
import 'package:time_tracker/widgets/add_project_dialog.dart';

class ProjectsManagementScreen extends StatelessWidget {
  const ProjectsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Projects'),
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.projects.length,
            itemBuilder: (context, index) {
              final category = provider.projects[index];
              return ListTile(
                title: Text(category.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    provider.deleteProject(category.id);
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
            builder: (context) => AddProjectDialog(
              onAdd: (newProject) {
                Provider.of<TimeEntryProvider>(context, listen: false)
                    .addOrUpdateProject(newProject);
                Navigator.pop(
                    context); // Close the dialog after adding the new tag
              },
            ),
          );
        },
        tooltip: 'Add Project',
        child: const Icon(Icons.add),
      ),
    );
  }
}
