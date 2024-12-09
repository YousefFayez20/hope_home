import '../models/communication_strategy.dart';

class CommunicationController {
  CommunicationStrategy? _strategy;

  void setStrategy(CommunicationStrategy strategy) {
    _strategy = strategy;
  }

  void notifyUser(String recipient, String message) {
    if (_strategy == null) {
      print('Error: Communication strategy is not set.');
      return;
    }
    try {
      _strategy!.sendMessage(recipient, message);
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  bool hasStrategy() {
    return _strategy != null;
  }

  void logNotification(String recipient, String message) {
    print('Notification logged for $recipient: $message');
  }
}