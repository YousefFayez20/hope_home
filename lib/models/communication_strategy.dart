// lib/models/communication_strategy.dart

abstract class CommunicationStrategy {
  void sendMessage(String recipient, String message);
}

// Concrete Strategy: Email
class EmailStrategy implements CommunicationStrategy {
  @override
  void sendMessage(String recipient, String message) {
    print('Sending Email to $recipient: $message');
    // Logic for sending an email
  }
}

// Concrete Strategy: SMS
class SMSStrategy implements CommunicationStrategy {
  @override
  void sendMessage(String recipient, String message) {
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
  }}
  class WhatsappMessageStrategy implements CommunicationStrategy {
  @override
  void sendMessage(String recipient, String message) {
    print('Sending Whatsapp Message to $recipient: $message');
    // Logic for sending a whatsapp message
  }
  }