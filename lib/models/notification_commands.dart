import 'command.dart';

/// Command for logging actions performed in the system
class LogActionCommand implements Command {
  final String actionType; // The type of action performed (e.g., Add Donation, Update Donation)
  final String message; // A detailed message describing the action
  final List<Map<String, String>> logList; // Shared log list to track all actions

  LogActionCommand(this.actionType, this.message, this.logList);

  @override
  Future<void> execute() async {
    // Add the action details to the log list
    logList.add({'action': actionType, 'message': message});
    print("Action logged: $actionType - $message");
    return; // Explicitly return Future<void>
  }

  @override
  Future<void> undo() async {
    // Undo is not applicable for this log command
    print("Undo not applicable for LogActionCommand.");
    return; // Explicitly return Future<void>
  }
}

/// Command for clearing all logs
class ClearLogsCommand implements Command {
  final List<Map<String, String>> logList; // Reference to the shared log list

  ClearLogsCommand(this.logList);

  @override
  Future<void> execute() async {
    // Clear the log list
    logList.clear();
    print("All logs cleared.");
    return; // Explicitly return Future<void>
  }

  @override
  Future<void> undo() async {
    // Undo is not applicable for clearing logs
    print("Undo not applicable for ClearLogsCommand.");
    return; // Explicitly return Future<void>
  }
}

/// Command to filter logs based on action type
class FilterLogsCommand implements Command {
  final String filterActionType; // The action type to filter by (e.g., Add Donation)
  final List<Map<String, String>> logList; // Reference to the shared log list

  FilterLogsCommand(this.filterActionType, this.logList);

  Future<List<Map<String, String>>> executeWithFilter() async {
    // Filter the logs by the specified action type
    final filteredLogs = logList
        .where((log) => log['action'] == filterActionType)
        .toList();
    print("Filtered logs for action type: $filterActionType");
    return filteredLogs;
  }

  @override
  Future<void> execute() async {
    // Optionally, print the filtered logs directly
    final filteredLogs = await executeWithFilter();
    filteredLogs.forEach((log) {
      print("Filtered Log - Action: ${log['action']}, Message: ${log['message']}");
    });
    return; // Explicitly return Future<void>
  }

  @override
  Future<void> undo() async {
    // Undo is not applicable for filtering logs
    print("Undo not applicable for FilterLogsCommand.");
    return; // Explicitly return Future<void>
  }
}