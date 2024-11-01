// lib/views/push_notification_screen.dart

import 'package:flutter/material.dart';
import '../controllers/communication_controller.dart';
import '../models/communication_strategy.dart';

class PushNotificationScreen extends StatelessWidget {
  final CommunicationController controller = CommunicationController();

  PushNotificationScreen() {
    controller.setStrategy(PushNotificationStrategy());
  }

  final TextEditingController recipientController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  void sendNotification(BuildContext context) {
    String recipient = recipientController.text;
    String message = messageController.text;
    controller.notifyUser(recipient, message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Push Notification sent to $recipient')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Push Notification')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: recipientController,
              decoration: InputDecoration(labelText: 'Recipient Device ID'),
            ),
            TextField(
              controller: messageController,
              decoration: InputDecoration(labelText: 'Message'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => sendNotification(context),
              child: Text('Send Push Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
