import 'package:flutter/material.dart';
import 'notification_screen.dart';
import 'communication_screen.dart';
import 'receipt_screen.dart';
import 'donation_history.dart';
import 'add_donation_screen.dart';
import 'receipt_history_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.message, 'label': 'Communications', 'screen': CommunicationScreen()},
    {'icon': Icons.receipt_long, 'label': 'Generate Receipts', 'screen': ReceiptScreen()},
    {'icon': Icons.history, 'label': 'Donation History', 'screen': DonationHistoryScreen()},
    {'icon': Icons.add_circle, 'label': 'Add Donation', 'screen': AddDonationScreen()},
    {'icon': Icons.list_alt, 'label': 'View Receipts', 'screen': ReceiptHistoryScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HopeHome Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item['screen']),
              );
            },
            child: Card(
              elevation: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'], size: 50, color: Colors.blue),
                  SizedBox(height: 8),
                  Text(item['label'], style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}