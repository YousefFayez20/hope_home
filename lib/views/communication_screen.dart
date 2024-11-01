// lib/views/communication_screen.dart

import 'package:flutter/material.dart';
import 'email_screen.dart';
import 'sms_screen.dart';
import 'push_notification_screen.dart';

class CommunicationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Communication Method'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailScreen()),
                );
              },
              child: Text('Send Email'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SMSScreen()),
                );
              },
              child: Text('Send SMS'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PushNotificationScreen()),
                );
              },
              child: Text('Send Push Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
