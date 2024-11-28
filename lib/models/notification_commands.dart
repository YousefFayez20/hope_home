import 'command.dart';
import '../controllers/communication_controller.dart';

class SendNotificationCommand implements Command {
  final CommunicationController communicationController;
  final String recipient;
  final String message;

  SendNotificationCommand(this.communicationController, this.recipient, this.message);

  @override
  Future<void> execute() async {
    try {
      communicationController.notifyUser(recipient, message);
      print("Notification sent to $recipient.");
    } catch (e) {
      print("Error sending notification to $recipient: $e");
    }
  }

  @override
  void undo() {
    print("Undo not applicable for SendNotificationCommand.");
  }

  bool isRecipientValid() {
    return recipient.contains("@") || RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(recipient);
  }
}

class SendBulkNotificationsCommand implements Command {
  final CommunicationController communicationController;
  final List<String> recipients;
  final String message;

  SendBulkNotificationsCommand(this.communicationController, this.recipients, this.message);

  @override
  Future<void> execute() async {
    List<String> failedRecipients = [];

    for (String recipient in recipients) {
      try {
        communicationController.notifyUser(recipient, message);
        print("Notification sent to $recipient.");
      } catch (e) {
        print("Error sending notification to $recipient: $e");
        failedRecipients.add(recipient);
      }
    }

    if (failedRecipients.isNotEmpty) {
      print("Failed to send notifications to the following recipients: ${failedRecipients.join(', ')}");
    }
  }

  @override
  void undo() {
    print("Undo not applicable for bulk notifications.");
  }
}

class ResendNotificationCommand implements Command {
  final CommunicationController communicationController;
  final String recipient;
  final String message;

  ResendNotificationCommand(this.communicationController, this.recipient, this.message);

  @override
  Future<void> execute() async {
    try {
      communicationController.notifyUser(recipient, message);
      print("Notification resent to $recipient.");
    } catch (e) {
      print("Error resending notification to $recipient: $e");
    }
  }

  @override
  void undo() {
    print("Undo not applicable for ResendNotificationCommand.");
  }
}

class ScheduleNotificationCommand implements Command {
  final CommunicationController communicationController;
  final String recipient;
  final String message;
  final DateTime scheduleTime;

  ScheduleNotificationCommand(
      this.communicationController,
      this.recipient,
      this.message,
      this.scheduleTime,
      );

  @override
  Future<void> execute() async {
    print("Notification scheduled for $scheduleTime to $recipient.");
    // Add logic to store the notification in a database or queue for scheduling
  }

  @override
  void undo() {
    print("Undo not applicable for ScheduleNotificationCommand.");
  }

  Duration timeUntilNotification() {
    return scheduleTime.difference(DateTime.now());
  }
}

class LogNotificationCommand implements Command {
  final String notificationType;
  final String recipient;

  LogNotificationCommand(this.notificationType, this.recipient);

  @override
  Future<void> execute() async {
    print("Notification of type '$notificationType' sent to $recipient.");
    // Add logic to log the notification in a database or file
  }

  @override
  void undo() {
    print("Undo not applicable for LogNotificationCommand.");
  }

  bool isLogged() {
    // Add logic to verify if the notification was logged
    return true;
  }
}