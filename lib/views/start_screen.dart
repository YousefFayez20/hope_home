// lib/views/start_screen.dart

import 'package:flutter/material.dart';
import 'communication_screen.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orphanage Management System'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommunicationScreen()),
                );
              },
              child: Text('Test Communication Strategies'),
            ),
          ],
        ),
      ),
    );
  }
}
