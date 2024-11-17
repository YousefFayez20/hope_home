import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class DonationHistoryScreen extends StatefulWidget {
  @override
  _DonationHistoryScreenState createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  late Future<List<Map<String, dynamic>>> donations;

  @override
  void initState() {
    super.initState();
    _fetchDonations();
  }

  void _fetchDonations() {
    setState(() {
      donations = DatabaseHelper.instance.getDonations();
    });
  }

  Future<void> _deleteDonation(int id) async {
    await DatabaseHelper.instance.deleteDonation(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Donation deleted successfully.')),
    );
    _fetchDonations();
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
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteDonation(donation['id']),
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
