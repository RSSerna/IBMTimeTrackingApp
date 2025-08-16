import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/time_entry.dart';
import 'package:time_tracker/provider/time_entry_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key, this.timeEntry});
  final TimeEntry? timeEntry;

  @override
  AddTimeEntryScreenState createState() => AddTimeEntryScreenState();
}

class AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String projectId = 'Project 1';
  String taskId = 'Task 1';
  double totalTime = 0.0;
  String notes = '';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    if (widget.timeEntry != null) {
      projectId = widget.timeEntry!.projectId;
      taskId = widget.timeEntry!.taskId;
      totalTime = widget.timeEntry!.totalTime;
      notes = widget.timeEntry!.notes;
      selectedDate = widget.timeEntry!.date;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Time Entry'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: Consumer<TimeEntryProvider>(builder: (context, provider, child) {
        var projects = provider.projects;
        var tasks = provider.task;
        projectId = projects.isNotEmpty ? projects[0].name : projectId;
        taskId = projects.isNotEmpty ? tasks[0].name : taskId;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: projectId,
                  onChanged: (String? newValue) {
                    setState(() {
                      projectId = newValue!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Project'),
                  items: projects.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value.name,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
                DropdownButtonFormField<String>(
                  value: taskId,
                  onChanged: (String? newValue) {
                    setState(() {
                      taskId = newValue!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Task'),
                  items: tasks.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value.name,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date: 	${selectedDate.toLocal().toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Text('Select Date'),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Total Time (hours)'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total time';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) => totalTime = double.parse(value!),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Notes'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some notes';
                    }
                    return null;
                  },
                  onSaved: (value) => notes = value!,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Provider.of<TimeEntryProvider>(context, listen: false)
                          .addOrUpdateEntry(TimeEntry(
                        id: DateTime.now().toString(), // Simple ID generation
                        projectId: projectId,
                        taskId: taskId,
                        totalTime: totalTime,
                        date: DateTime.now(),
                        notes: notes,
                      ));
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save'),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
