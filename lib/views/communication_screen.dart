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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title for the screen
            Text(
              'Choose a Method:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // Spacing

            // Send Email Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailScreen()),
                );
              },
              icon: Icon(Icons.email),
              label: Text('Send Email'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            SizedBox(height: 16), // Spacing

            // Send SMS Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SMSScreen()),
                );
              },
              icon: Icon(Icons.sms),
              label: Text('Send SMS'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            SizedBox(height: 16), // Spacing

            // Send Push Notification Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PushNotificationScreen()),
                );
              },
              icon: Icon(Icons.notifications),
              label: Text('Send Push Notification'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
