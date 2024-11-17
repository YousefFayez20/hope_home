import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/receipt.dart';
import '../models/tax_info_decorator.dart';
import '../models/appreciation_decorator.dart';
import '../models/footer_decorator.dart';

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
    String donorName = donorNameController.text.trim();
    double? amount = double.tryParse(amountController.text);

    if (donorName.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide valid donor name and amount.')),
      );
      return;
    }

    Receipt receipt = BasicReceipt(donorName, amount);

    if (includeTaxInfo) receipt = TaxInfoDecorator(receipt);
    if (includeAppreciation) receipt = AppreciationDecorator(receipt);
    if (includeFooter) receipt = FooterDecorator(receipt);

    setState(() {
      generatedReceipt = receipt.generate();
    });

    DatabaseHelper.instance.insertReceipt(receipt.toJson()).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Receipt generated and stored successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error storing receipt: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate Receipt')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text("Include Tax Information"),
              value: includeTaxInfo,
              onChanged: (value) => setState(() => includeTaxInfo = value ?? false),
            ),
            CheckboxListTile(
              title: Text("Add Appreciation Note"),
              value: includeAppreciation,
              onChanged: (value) => setState(() => includeAppreciation = value ?? false),
            ),
            CheckboxListTile(
              title: Text("Add Footer"),
              value: includeFooter,
              onChanged: (value) => setState(() => includeFooter = value ?? false),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: generateAndStoreReceipt,
              child: Text('Generate and Store Receipt'),
            ),
            SizedBox(height: 16),
            if (generatedReceipt != null)
              Text(
                'Generated Receipt:\n$generatedReceipt',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
