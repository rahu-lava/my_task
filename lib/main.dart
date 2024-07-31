import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:my_task/task_provider.dart';
import 'package:my_task/task_list_screen.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskListScreen(),
    );
  }
}
