import 'package:flutter/material.dart';
import '../controllers/communication_controller.dart';
import '../models/communication_strategy.dart';

class EmailScreen extends StatelessWidget {
  final CommunicationController controller = CommunicationController();

  EmailScreen() {
    controller.setStrategy(EmailStrategy());
  }

  final TextEditingController recipientController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  void sendEmail(BuildContext context) {
    String recipient = recipientController.text;
    String message = messageController.text;
    controller.notifyUser(recipient, message);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email sent to $recipient'))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Email')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: recipientController,
              decoration: InputDecoration(labelText: 'Recipient Email'),
            ),
            TextField(
              controller: messageController,
              decoration: InputDecoration(labelText: 'Message'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => sendEmail(context),
              child: Text('Send Email'),
            ),
          ],
        ),
      ),
    );
  }
}