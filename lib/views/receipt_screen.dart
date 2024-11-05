import 'package:flutter/material.dart';
import '../models/receipt.dart';

import '../models/tax_info_decorator.dart';
import '../models/appreciation_decorator.dart';
import '../models/footer_decorator.dart';
import '../data/database_helper.dart'; // Import DatabaseHelper

class ReceiptScreen extends StatefulWidget {
  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final TextEditingController donorNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  bool includeTaxInfo = false;
  bool includeAppreciation = false;
  bool includeFooter = false;

  String? generatedReceipt;

  void generateAndStoreReceipt() {
    String donorName = donorNameController.text;
    double amount = double.tryParse(amountController.text) ?? 0;

    Receipt receipt = BasicReceipt(donorName, amount);

    // Apply selected decorators
    if (includeTaxInfo) {
      receipt = TaxInfoDecorator(receipt);
    }
    if (includeAppreciation) {
      receipt = AppreciationDecorator(receipt);
    }
    if (includeFooter) {
      receipt = FooterDecorator(receipt);
    }

    setState(() {
      generatedReceipt = receipt.generate();
    });

    // Store the receipt in the database
    DatabaseHelper.instance.insertReceipt(receipt.toJson()).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Receipt generated and stored successfully!'))
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error storing receipt: $error'))
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate Donation Receipt')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            SizedBox(height: 20),
            CheckboxListTile(
              title: Text("Include Tax Information"),
              value: includeTaxInfo,
              onChanged: (bool? value) {
                setState(() {
                  includeTaxInfo = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: Text("Add Appreciation Note"),
              value: includeAppreciation,
              onChanged: (bool? value) {
                setState(() {
                  includeAppreciation = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: Text("Add Organization Footer"),
              value: includeFooter,
              onChanged: (bool? value) {
                setState(() {
                  includeFooter = value ?? false;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: generateAndStoreReceipt,
              child: Text('Generate and Store Receipt'),
            ),
            SizedBox(height: 20),
            if (generatedReceipt != null)
              Text(
                generatedReceipt!,
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}