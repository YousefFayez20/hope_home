import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import '../managers/notification_manager.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, String>> logList = NotificationManager.instance.logList;
  String? selectedFilter;

  // Filters logs based on the selected action type
  void _filterLogs(String? actionType) {
    setState(() {
      selectedFilter = actionType;
      if (selectedFilter == null || selectedFilter == "All") {
        logList = NotificationManager.instance.logList;
      } else {
        logList = NotificationManager.instance.logList
            .where((log) => log['action'] == selectedFilter)
            .toList();
      }
    });
  }

  // Clears all logs and refreshes the screen
  void _clearLogs() {
    NotificationManager.instance.clearLogs();
    setState(() {
      logList = NotificationManager.instance.logList;
    });
  }

  // Shares the log file directly
  Future<void> _shareLogFile() async {
    try {
      // Prepare the CSV content
      final csvData = [
        ['Action', 'Message'], // Header row
        ...logList.map((log) => [log['action'], log['message']]) // Log rows
      ];
      final csvContent = const ListToCsvConverter().convert(csvData);

      // Get the application's document directory
      final directory = await getApplicationDocumentsDirectory();

      // Define the file path temporarily in the documents directory
      final file = File('${directory.path}/notifications_logs.csv');

      // Write the CSV content to the file
      await file.writeAsString(csvContent);

      // Share the file
      await Share.shareXFiles([XFile(file.path)], text: 'Here is the notifications log file.');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Log file shared successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share log file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: _clearLogs, // Clear logs and refresh screen
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareLogFile, // Share the log file
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedFilter,
              hint: Text("Filter by action"),
              isExpanded: true,
              items: ["All", "Add Donation", "Update Donation", "Delete Donation"]
                  .map((action) => DropdownMenuItem(
                value: action,
                child: Text(action),
              ))
                  .toList(),
              onChanged: _filterLogs,
            ),
          ),
          Expanded(
            child: logList.isEmpty
                ? Center(child: Text("No notifications yet."))
                : ListView.builder(
              itemCount: logList.length,
              itemBuilder: (context, index) {
                final log = logList[index];
                return ListTile(
                  leading: Icon(Icons.notifications, color: Colors.blue),
                  title: Text(log['action'] ?? ""),
                  subtitle: Text(log['message'] ?? ""),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}