import 'package:flutter/material.dart';
import 'package:flutter_exercise1_todolist/core/services/notification_service.dart';
import 'package:flutter_exercise1_todolist/data/datasources/local/task_sqlite_datasource.dart';
import 'package:flutter_exercise1_todolist/presentation/screens/search/search_screen.dart';
import 'package:flutter_exercise1_todolist/presentation/screens/tasks/tasks_screen.dart';
import 'package:flutter_exercise1_todolist/core/themes/theme.dart';
import 'package:flutter_exercise1_todolist/core/themes/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TaskSqliteDatasource().database;
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(context, "Roboto", "Inter");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Placeholder screens for navigation
  final List<Widget> _screens = [const TasksScreen(), const SearchScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(
          context,
        ).colorScheme.primary.withAlpha(150),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }
}
