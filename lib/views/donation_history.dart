// lib/views/donation_history.dart

import 'package:flutter/material.dart';

class DonationHistory extends StatelessWidget {
  // Sample data for demonstration
  final List<Map<String, dynamic>> donations = [
    {"date": "2023-10-01", "amount": 100.0, "type": "Cash"},
    {"date": "2023-09-15", "amount": 50.0, "type": "In-kind"},
    {"date": "2023-08-20", "amount": 200.0, "type": "Online"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Donation History")),
      body: ListView.builder(
        itemCount: donations.length,
        itemBuilder: (context, index) {
          final donation = donations[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ListTile(
              title: Text("Donation of \$${donation['amount']}"),
              subtitle: Text("Date: ${donation['date']} | Type: ${donation['type']}"),
            ),
          );
        },
      ),
    );
  }
}
