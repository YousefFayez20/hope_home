import 'package:flutter/material.dart';
import 'communication_screen.dart';
import 'receipt_screen.dart';
import 'donation_history.dart';
import 'add_donation_screen.dart';
import 'receipt_history_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Calculate the cross-axis count based on screen width
    int crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: Text('HopeHome'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: GridView.count(
          crossAxisCount: crossAxisCount,
          padding: EdgeInsets.all(16.0),
          childAspectRatio: MediaQuery.of(context).size.width > 600 ? 1.5 : 1, // Adjust aspect ratio based on screen width
          children: List.generate(5, (index) {
            return HomeOption(
              index: index,
              onTap: () => _handleNavigation(context, index),
            );
          }),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => CommunicationScreen()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiptScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => DonationHistoryScreen()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddDonationScreen()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiptHistoryScreen()));
        break;
    }
  }
}

class HomeOption extends StatelessWidget {
  final int index;
  final VoidCallback onTap;

  HomeOption({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    List<IconData> icons = [
      Icons.message,
      Icons.receipt,
      Icons.history,
      Icons.add_circle_outline,
      Icons.list,
    ];
    List<String> labels = [
      'Communications',
      'Generate Receipts',
      'Donation History',
      'Add Donation',
      'View Receipts',
    ];

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icons[index], size: 40),
            SizedBox(height: 10),
            Text(labels[index]),
          ],
        ),
      ),
    );
  }
}