import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import 'edit_donation_screen.dart';

class DonationHistoryScreen extends StatefulWidget {
  @override
  _DonationHistoryScreenState createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  late Future<List<Map<String, dynamic>>> donations;

  @override
  void initState() {
    super.initState();
    _refreshDonations();
  }

  void _refreshDonations() {
    setState(() {
      donations = DatabaseHelper.instance.getDonations();
    });
  }

  Future<void> _deleteDonation(int id) async {
    await DatabaseHelper.instance.deleteDonation(id);
    _refreshDonations();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Donation deleted')),
    );
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
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final donation = snapshot.data![index];
                return ListTile(
                  leading: Icon(Icons.monetization_on, color: Colors.green),
                  title: Text(donation['donorName']),
                  subtitle: Text('${donation['donationType']} - \$${donation['amount']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditDonationScreen(
                                donationId: donation['id'],
                                donorName: donation['donorName'],
                                amount: donation['amount'],
                                donationType: donation['donationType'],
                              ),
                            ),
                          ).then((_) => _refreshDonations());
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteDonation(donation['id']),
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