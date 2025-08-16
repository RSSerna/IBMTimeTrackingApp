import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/time_entry.dart';
import 'package:time_tracker/provider/time_entry_provider.dart';
import 'package:time_tracker/screens/add_time_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Tracking"),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "All Entries"),
            Tab(text: "Grouped by Projects"),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.folder, color: Colors.green),
              title: const Text('Projects'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_categories');
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment, color: Colors.green),
              title: const Text('Tasks'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_tags');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildAllEntries(context),
          buildExpensesByCategory(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow[700],
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddTimeEntryScreen())),
        tooltip: 'Add Expense',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildAllEntries(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return _NoEntriesWidget();
        }
        return ListView.builder(
          itemCount: provider.entries.length,
          itemBuilder: (context, index) {
            final entry = provider.entries[index];
            return Dismissible(
              key: Key(entry.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                provider.deleteTimeEntry(entry.id);
              },
              background: Container(
                color: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                color: Colors.purple[50],
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: ListTile(
                  title: Text('${entry.projectId} - ${entry.totalTime} hours'),
                  subtitle:
                      Text('${entry.date.toString()} - Notes: ${entry.notes}'),
                  isThreeLine: true,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildExpensesByCategory(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return _NoEntriesWidget();
        }

        // Grouping expenses by category
        var grouped = groupBy(provider.entries, (TimeEntry e) => e.projectId);
        return ListView(
          children: grouped.entries.map((entry) {
            String projectName = getProjectNameById(context, entry.key);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    projectName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                ListView.builder(
                  physics:
                      const NeverScrollableScrollPhysics(), // to disable scrolling within the inner list view
                  shrinkWrap:
                      true, // necessary to integrate a ListView within another ListView
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) {
                    TimeEntry timeEntry = entry.value[index];
                    return ListTile(
                      leading: const Icon(Icons.monetization_on,
                          color: Colors.green),
                      title: Text(
                          "${timeEntry.taskId} - ${timeEntry.totalTime} hours"),
                      subtitle: Text(
                          DateFormat('MMM dd, yyyy').format(timeEntry.date)),
                    );
                  },
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  // home_screen.dart
  String getProjectNameById(BuildContext context, String projectId) {
    var project = Provider.of<TimeEntryProvider>(context, listen: false)
        .projects
        .firstWhere((project) => project.id == projectId);
    return project.name;
  }
}

class _NoEntriesWidget extends StatelessWidget {
  const _NoEntriesWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.hourglass_empty,
          size: 100,
          color: Colors.grey[600],
        ),
        Center(
          child: Text("No time entries yet!",
              style: TextStyle(color: Colors.grey[800], fontSize: 18)),
        ),
        Text("Tap the '+' button to add your first entry.",
            style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}
