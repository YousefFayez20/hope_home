import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class EditDonationScreen extends StatefulWidget {
  final int donationId;
  final String donorName;
  final double amount;
  final String donationType;

  EditDonationScreen({
    required this.donationId,
    required this.donorName,
    required this.amount,
    required this.donationType,
  });

  @override
  _EditDonationScreenState createState() => _EditDonationScreenState();
}

class _EditDonationScreenState extends State<EditDonationScreen> {
  late TextEditingController donorNameController;
  late TextEditingController amountController;
  late TextEditingController donationTypeController;

  @override
  void initState() {
    super.initState();
    donorNameController = TextEditingController(text: widget.donorName);
    amountController = TextEditingController(text: widget.amount.toString());
    donationTypeController = TextEditingController(text: widget.donationType);
  }

  Future<void> _updateDonation() async {
    String donorName = donorNameController.text;
    double amount = double.tryParse(amountController.text) ?? 0;
    String donationType = donationTypeController.text;

    await DatabaseHelper.instance.updateDonation(widget.donationId, donorName, amount, donationType);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Donation updated')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Donation')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: donorNameController,
              decoration: InputDecoration(labelText: 'Donor Name'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Donation Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: donationTypeController,
              decoration: InputDecoration(labelText: 'Donation Type (e.g., Cash, Online)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateDonation,
              child: Text('Update Donation'),
            ),
          ],
        ),
      ),
    );
  }
}