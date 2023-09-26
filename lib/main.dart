import 'package:flutter/material.dart';
import 'package:todo/core/router/router.dart';
import 'package:todo/core/router/todo_navigator.dart';
import 'package:todo/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      navigatorKey: sl<TodoNavigator>().navigatorKey,
      onGenerateRoute: generateRoute,
    );
  }
}
