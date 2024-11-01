// lib/views/sms_screen.dart

import 'package:flutter/material.dart';
import '../controllers/communication_controller.dart';
import '../models/communication_strategy.dart';

class SMSScreen extends StatelessWidget {
  final CommunicationController controller = CommunicationController();

  SMSScreen() {
    controller.setStrategy(SMSStrategy());
  }

  final TextEditingController recipientController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  void sendSMS(BuildContext context) {
    String recipient = recipientController.text;
    String message = messageController.text;
    controller.notifyUser(recipient, message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('SMS sent to $recipient')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send SMS')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: recipientController,
              decoration: InputDecoration(labelText: 'Recipient Phone Number'),
            ),
            TextField(
              controller: messageController,
              decoration: InputDecoration(labelText: 'Message'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => sendSMS(context),
              child: Text('Send SMS'),
            ),
          ],
        ),
      ),
    );
  }
}
