import 'package:flutter/material.dart';
import 'package:todo/service_locator.dart';

Future<void> main() async {
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: Container());
  }
}
