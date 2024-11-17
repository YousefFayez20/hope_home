import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class AddDonationScreen extends StatefulWidget {
  @override
  _AddDonationScreenState createState() => _AddDonationScreenState();
}

class _AddDonationScreenState extends State<AddDonationScreen> {
  final TextEditingController donorNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController donationTypeController = TextEditingController();

  String? amountErrorText;

  Future<void> saveDonation() async {
    if (!_validateAmount(amountController.text)) return;

    String donorName = donorNameController.text.trim();
    double amount = double.parse(amountController.text);
    String donationType = donationTypeController.text.trim();

    if (donorName.isEmpty || donationType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    await DatabaseHelper.instance.insertDonation(donorName, amount, donationType);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Donation added for $donorName')),
    );

    donorNameController.clear();
    amountController.clear();
    donationTypeController.clear();
  }

  bool _validateAmount(String value) {
    if (value.isEmpty || double.tryParse(value) == null || double.parse(value) <= 0) {
      setState(() {
        amountErrorText = 'Please enter a valid amount';
      });
      return false;
    }
    setState(() {
      amountErrorText = null;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Donation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: donorNameController,
              decoration: InputDecoration(
                labelText: 'Donor Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Donation Amount',
                errorText: amountErrorText,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => _validateAmount(value),
            ),
            SizedBox(height: 16),
            TextField(
              controller: donationTypeController,
              decoration: InputDecoration(
                labelText: 'Donation Type (e.g., Cash, Online)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: saveDonation,
              child: Text('Save Donation'),
            ),
          ],
        ),
      ),
    );
  }
}
