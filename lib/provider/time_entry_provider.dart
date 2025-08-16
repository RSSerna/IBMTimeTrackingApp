import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:time_tracker/models/project.dart';
import 'package:time_tracker/models/task.dart';
import 'package:time_tracker/models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;

  List<Project> _projects = [];
  List<Task> _tasks = [];
  final List<TimeEntry> _entries = [];

  List<TimeEntry> get entries => _entries;
  List<Project> get projects => _projects;
  List<Task> get task => _tasks;

  TimeEntryProvider(this.storage) {
    _loadData();
  }

  void _loadData() {
    // Load projects and entries from a data source or initialize them
    _loadProjects();
    _loadTasks();
    notifyListeners();
  }

  //TASKS
  void _loadTasks() {
    var storedTasks = storage.getItem('tasks');
    if (storedTasks != null) {
      _tasks = List<Task>.from(
        (storedTasks as List).map((item) => Task.fromJson(item)),
      );
    } else {
      // Initialize with default projects if none are stored
      _tasks = [
        Task(id: '1', name: 'Task 1'),
        Task(id: '2', name: 'Task 2'),
        Task(id: '3', name: 'Task 3'),
      ];
    }
  }

  // Save tasks to local storage
  void _saveTasksToStorage() {
    storage.setItem(
        'tasks', jsonEncode(_tasks.map((e) => e.toJson()).toList()));
  }

  // Add or update a task
  void addOrUpdateTask(Task tast) {
    int index = _tasks.indexWhere((e) => e.id == tast.id);
    if (index != -1) {
      // Update existing expense
      _tasks[index] = tast;
    } else {
      // Add new expense
      _tasks.add(tast);
    }
    _saveTasksToStorage(); // Save the updated list to local storage
    notifyListeners();
  }

  // Delete a task
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasksToStorage(); // Save the updated list to local storage
    notifyListeners();
  }

  // PROJECTS
  void _loadProjects() {
    var storedProjects = storage.getItem('projects');
    if (storedProjects != null) {
      _projects = List<Project>.from(
        (storedProjects as List).map((item) => Project.fromJson(item)),
      );
    } else {
      // Initialize with default projects if none are stored
      _projects = [
        Project(id: '1', name: 'Project 1'),
        Project(id: '2', name: 'Project 2'),
        Project(id: '3', name: 'Project 3'),
      ];
    }
  }

  // Save projects to local storage
  void _saveProjectsToStorage() {
    storage.setItem(
        'projects', jsonEncode(_projects.map((e) => e.toJson()).toList()));
  }

  // Add or update a project
  void addOrUpdateProject(Project project) {
    int index = _projects.indexWhere((e) => e.id == project.id);
    if (index != -1) {
      // Update existing project
      _projects[index] = project;
    } else {
      // Add new project
      _projects.add(project);
    }
    _saveProjectsToStorage(); // Save the updated list to local storage
    notifyListeners();
  }

  // Delete a project
  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _saveProjectsToStorage(); // Save the updated list to local storage
    notifyListeners();
  }
  // TIME ENTRIES
  // void _loadEntries() {
  //   var storedEntries = storage.getItem('entries');
  //   if (storedEntries != null) {
  //     _entries = List<TimeEntry>.from(
  //       (storedEntries as List).map((item) => TimeEntry.fromJson(item)),
  //     );
  //   } else {
  //     // Initialize with default entries if none are stored
  //     _entries = [
  //       TimeEntry(id: '1', projectId: '1', taskId: '1', totalTime: 2.0, notes: 'Initial entry'),
  //     ];
  //   }
  // }

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }
}
