// lib/observers/admin_notification_observer.dart

import 'observer.dart';

class AdminNotificationObserver implements Observer {
  @override
  void update() {
    print('Notification: A donation has been added, updated, or deleted.');
    // Here, you could extend this to send actual notifications (email, SMS, etc.)
    // For example:
    // CommunicationController().notifyUser("admin@orphanage.org", "Donation updated.");
  }
}