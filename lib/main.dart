// lib/main.dart

import 'package:flutter/material.dart';
import 'views/home_screen.dart';

void main() {
  runApp(OrphanageApp());
}

class OrphanageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
