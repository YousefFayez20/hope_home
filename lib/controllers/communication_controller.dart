
// lib/controllers/communication_controller.dart

import '../models/communication_strategy.dart';

class CommunicationController {
  CommunicationStrategy? _strategy;

  void setStrategy(CommunicationStrategy strategy) {
    _strategy = strategy;
  }

  void notifyUser(String recipient, String message) {
    if (_strategy == null) {
      print('Communication strategy is not set.');
      return;
    }
    _strategy!.sendMessage(recipient, message);
  }
}