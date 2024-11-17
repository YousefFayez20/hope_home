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
    String recipient = recipientController.text.trim();
    String message = messageController.text.trim();

    if (recipient.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Both recipient and message are required.')),
      );
      return;
    }

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: recipientController,
              decoration: InputDecoration(
                labelText: 'Recipient Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 24),
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
