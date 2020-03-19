import 'package:flutter/material.dart';
import 'navigation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nagger',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Navigation(),
    );
  }
}
