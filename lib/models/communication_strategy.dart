// lib/models/communication_strategy.dart

import 'dart:io';

// Abstract Strategy
abstract class CommunicationStrategy {
  void sendMessage(String recipient, String message);
}

// Concrete Strategy: Email
class EmailStrategy implements CommunicationStrategy {
  @override
  void sendMessage(String recipient, String message) {
    if (!recipient.contains('@')) {
      throw Exception('Invalid email address');
    }
    print('Sending Email to $recipient: $message');
    // Logic for sending an email
  }
}

// Concrete Strategy: SMS
class SMSStrategy implements CommunicationStrategy {
  @override
  void sendMessage(String recipient, String message) {
    if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(recipient)) {
      throw Exception('Invalid phone number format');
    }
    print('Sending SMS to $recipient: $message');
    // Logic for sending an SMS
  }
}

// Concrete Strategy: Push Notification
class PushNotificationStrategy implements CommunicationStrategy {
  @override
  void sendMessage(String recipient, String message) {
    print('Sending Push Notification to $recipient: $message');
    // Logic for sending a push notification
  }
}

// Concrete Strategy: WhatsApp
class WhatsAppStrategy implements CommunicationStrategy {
  @override
  void sendMessage(String recipient, String message) {
    if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(recipient)) {
      throw Exception('Invalid WhatsApp number format');
    }
    print('Sending WhatsApp message to $recipient: $message');
    // Logic for sending a WhatsApp message
  }
}

// Notification Template Class
class NotificationTemplate {
  static String getTemplate(String type) {
    switch (type) {
      case 'welcome':
        return 'Welcome to our service!';
      case 'reminder':
        return 'This is a friendly reminder!';
      case 'thank_you':
        return 'Thank you for your support!';
      default:
        return 'Hello, we appreciate you!';
    }
  }
}

// Postcard Functionality
class PostcardMaker {
  final String recipientName;
  final String message;
  final File? image; // Optional image for the postcard

  PostcardMaker({
    required this.recipientName,
    required this.message,
    this.image,
  });

  void createPostcard() {
    print('Creating a postcard for $recipientName...');
    print('Message: $message');
    if (image != null) {
      print('Attaching image: ${image!.path}');
    } else {
      print('No image attached.');
    }
    // Logic to generate a postcard (e.g., save as PDF or image)
    print('Postcard successfully created for $recipientName!');
  }
}

// Example Usage of Postcards
void main() {
  // Create a postcard
  PostcardMaker postcard = PostcardMaker(
    recipientName: 'John Doe',
    message: NotificationTemplate.getTemplate('thank_you'),
    image: File('path/to/image.jpg'), // Replace with actual file path or null
  );

  // Generate the postcard
  postcard.createPostcard();
}