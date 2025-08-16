import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/provider/time_entry_provider.dart';
import 'package:time_tracker/screens/home_screen.dart';
import 'package:time_tracker/screens/projects_managment_screen.dart';
import 'package:time_tracker/screens/task_managment_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;

  const MyApp({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeEntryProvider(localStorage)),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(), // Main entry point, HomeScreen
          '/manage_categories': (context) =>
              const ProjectsManagementScreen(), // Route for managing categories
          '/manage_tags': (context) =>
              const TaskManagementScreen(), // Route for managing tags
        },
        // Removed 'home:' since 'initialRoute' is used to define the home route
      ),
    );
  }
}
