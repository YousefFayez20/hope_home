import 'package:flutter/material.dart';
import 'views/welcome_screen.dart';

void main() {
  runApp(OrphanageApp());
}

class OrphanageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Orphanage Management System',
      theme: ThemeData(
        // Using primarySwatch to define the primary color and generate shades.
        primarySwatch: Colors.blueGrey,
        // Defining a ColorScheme that handles more nuanced theming capabilities.
        colorScheme: ColorScheme.light(
          primary: Colors.blueGrey,
          onPrimary: Colors.white, // Text/icon color on top of the primary color.
          secondary: Colors.amber,
          onSecondary: Colors.black, // Text/icon color on top of the secondary color.
        ),
        // Ensuring all text styles are updated and accessible.
        textTheme: const TextTheme(
          titleMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 14.0, color: Colors.black),
        ),
        // Using ElevatedButton's default style to replace deprecated button themes.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blueGrey, // Text color
          ),
        ),
      ),
      home: WelcomeScreen(),
    );
  }
}