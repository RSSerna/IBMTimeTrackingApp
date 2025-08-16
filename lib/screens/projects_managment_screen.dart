import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/project.dart';
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
              final project = provider.projects[index];
              return ListTile(
                title: Text(project.name),
                leading: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Edit
                    addOrUpdateProject(context, project: project);
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    provider.deleteProject(project.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addOrUpdateProject(context);
        },
        tooltip: 'Add Project',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> addOrUpdateProject(BuildContext context, {Project? project}) {
    return showDialog(
      context: context,
      builder: (context) => AddProjectDialog(
        project: project,
        onAdd: (newProject) {
          Provider.of<TimeEntryProvider>(context, listen: false)
              .addOrUpdateProject(newProject);
          Navigator.pop(context); // Close the dialog after adding the new tag
        },
      ),
    );
  }
}
