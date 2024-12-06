import 'package:flutter/material.dart';
import '../models/donation_commands.dart';
import '../managers/donation_manager.dart';
import '../data/database_helper.dart';
import 'add_donation_screen.dart';

class DonationHistoryScreen extends StatefulWidget {
  @override
  _DonationHistoryScreenState createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  late Future<List<Map<String, dynamic>>> donations;
  final DonationManager donationManager = DonationManager(DatabaseHelper.instance);

  DeleteDonationCommand? lastDeleteCommand; // Store the last delete command for undo

  @override
  void initState() {
    super.initState();
    _fetchDonations();
  }

  void _fetchDonations() {
    setState(() {
      donations = donationManager.databaseHelper.getDonations();
    });
  }

  Future<void> _deleteDonation(Map<String, dynamic> donation) async {
    final deleteCommand = DeleteDonationCommand(donationManager, donation['id']);
    await deleteCommand.execute();
    lastDeleteCommand = deleteCommand; // Store for undo

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Donation deleted successfully.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            await lastDeleteCommand?.undo();
            if (mounted) {
              _fetchDonations(); // Refresh list after undo
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Delete operation undone.')),
              );
            }
          },
        ),
      ),
    );

    _fetchDonations(); // Refresh list after deletion
  }

  Future<void> _editDonation(Map<String, dynamic> donation) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDonationScreen(
          donationId: donation['id'],
          donorName: donation['donorName'],
          amount: (donation['amount'] as num).toDouble(),
          donationType: donation['donationType'],
          onDonationChanged: _fetchDonations, // Notify history screen to refresh
        ),
      ),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Donation updated for ${donation['donorName']}')),
      );
      _fetchDonations(); // Refresh list after editing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Donation History')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: donations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No donations found.'));
          } else {
            return ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final donation = snapshot.data![index];
                return ListTile(
                  leading: Icon(Icons.monetization_on, color: Colors.green),
                  title: Text(donation['donorName']),
                  subtitle: Text(
                    'Amount: \$${donation['amount']} (${donation['donationType']})',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editDonation(donation),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteDonation(donation),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
