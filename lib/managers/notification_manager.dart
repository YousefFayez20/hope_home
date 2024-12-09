class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  NotificationManager._internal();
  static NotificationManager get instance => _instance;
  final List<Map<String, String>> _logList = [];
  List<Map<String, String>> get logList => _logList;

  void clearLogs() {
    _logList.clear();
    print("All logs cleared.");
  }
}