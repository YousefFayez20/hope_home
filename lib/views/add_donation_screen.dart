import 'package:flutter/material.dart';
import '../managers/donation_manager.dart';
import '../data/database_helper.dart';
import '../models/donation_commands.dart';

class AddDonationScreen extends StatefulWidget {
  final int? donationId; // ID of the donation (null for new donations)
  final String? donorName; // Existing donor name
  final double? amount; // Existing donation amount
  final String? donationType; // Existing donation type
  final VoidCallback? onDonationChanged; // Callback to refresh donation history

  AddDonationScreen({
    this.donationId,
    this.donorName,
    this.amount,
    this.donationType,
    this.onDonationChanged,
  });

  @override
  _AddDonationScreenState createState() => _AddDonationScreenState();
}

class _AddDonationScreenState extends State<AddDonationScreen> {
  final TextEditingController donorNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController donationTypeController = TextEditingController();

  final DonationManager donationManager = DonationManager(DatabaseHelper.instance);

  String? amountErrorText;

  @override
  void initState() {
    super.initState();

    // Pre-fill the fields with existing donation data if editing
    if (widget.donationId != null) {
      donorNameController.text = widget.donorName ?? '';
      amountController.text = widget.amount?.toString() ?? '';
      donationTypeController.text = widget.donationType ?? '';
    }
  }

  Future<void> saveDonation() async {
    if (!_validateAmount(amountController.text)) return;

    String donorName = donorNameController.text.trim();
    double amount = double.parse(amountController.text);
    String donationType = donationTypeController.text.trim();

    if (donorName.isEmpty || donationType.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('All fields are required')),
        );
      }
      return;
    }

    if (widget.donationId == null) {
      final addCommand = AddDonationCommand(donationManager, donorName, amount, donationType);
      await addCommand.execute();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Donation added for $donorName')),
        );
      }
    } else {
      final updateCommand = UpdateDonationCommand(
        donationManager,
        widget.donationId!,
        donorName,
        amount,
        donationType,
      );

      await updateCommand.execute();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Donation updated for $donorName')),
        );
      }
    }

    widget.onDonationChanged?.call();
    if (mounted) Navigator.pop(context, true); // Return to previous screen
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
      appBar: AppBar(title: Text(widget.donationId == null ? 'Add Donation' : 'Edit Donation')),
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
              child: Text(widget.donationId == null ? 'Save Donation' : 'Update Donation'),
            ),
          ],
        ),
      ),
    );
  }
}
