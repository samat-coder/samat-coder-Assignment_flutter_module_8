import 'package:flutter/material.dart';
import 'package:sqflitedemo/practice_sqlite/adddata.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyAddScreen(),
    );
  }
}
