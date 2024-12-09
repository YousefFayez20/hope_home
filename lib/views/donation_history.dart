import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../managers/donation_manager.dart';
import '../models/donation_commands.dart';
import 'add_donation_screen.dart';

class DonationHistoryScreen extends StatefulWidget {
  @override
  _DonationHistoryScreenState createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  late Future<List<Map<String, dynamic>>> donations;
  final DonationManager donationManager = DonationManager(
      DatabaseHelper.instance);

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

  Future<void> _deleteDonation(int id, String donorName) async {
    final deleteCommand = DeleteDonationCommand(DatabaseHelper.instance, id);
    await deleteCommand.execute();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Donation deleted for $donorName.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            await deleteCommand.undo();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Delete operation undone for $donorName.')),
            );
            _fetchDonations(); // Refresh the list after undo
          },
        ),
      ),
    );

    _fetchDonations(); // Refresh the list after deletion
  }

  Future<void> _navigateToEditDonation(Map<String, dynamic> donation) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddDonationScreen(
              donationId: donation['id'],
              donorName: donation['donorName'],
              amount: donation['amount'],
              donationType: donation['donationType'],
              onDonationChanged: _fetchDonations,
            ),
      ),
    );

    if (result == true) {
      _fetchDonations(); // Refresh the donation list
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
                        onPressed: () => _navigateToEditDonation(donation),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _deleteDonation(
                              donation['id'],
                              donation['donorName'],
                            ),
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