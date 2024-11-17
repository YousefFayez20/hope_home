import 'package:flutter/material.dart';
import '../controllers/communication_controller.dart';
import '../models/communication_strategy.dart';

class WhatsappMessageScreen extends StatelessWidget {
  final CommunicationController controller = CommunicationController();

  WhatsappMessageScreen() {
    controller.setStrategy(WhatsappMessageStrategy());
  }

  final TextEditingController recipientController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  void sendmsg(BuildContext context) {
    String recipient = recipientController.text;
    String message = messageController.text;
    controller.notifyUser(recipient, message);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('WhatsApp message sent to $recipient'))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send message')),
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
              onPressed: () => sendmsg(context),
              child: Text('Send message'),
            ),
          ],
        ),
      ),
    );
  }
}