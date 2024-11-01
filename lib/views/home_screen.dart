// lib/views/home_screen.dart

import 'package:flutter/material.dart';
import 'communication_screen.dart';
import 'receipt_screen.dart';
import 'donation_history.dart'; // Import the Donation History screen

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orphanage Management System'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommunicationScreen()),
                );
              },
              child: Text('Communication Feature (Strategy Pattern)'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReceiptScreen()),
                );
              },
              child: Text('Receipt Generation (Decorator Pattern)'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonationHistory()),
                );
              },
              child: Text('View Donation History'),
            ),
          ],
        ),
      ),
    );
  }
}
