import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class ReceiptHistoryScreen extends StatefulWidget {
  @override
  _ReceiptHistoryScreenState createState() => _ReceiptHistoryScreenState();
}

class _ReceiptHistoryScreenState extends State<ReceiptHistoryScreen> {
  late Future<List<Map<String, dynamic>>> receipts;

  @override
  void initState() {
    super.initState();
    receipts = DatabaseHelper.instance.getReceipts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: receipts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No receipts found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var receipt = snapshot.data![index];
                return ListTile(
                  title: Text('Receipt for: ${receipt['donorName']}'),
                  subtitle: Text('Amount: \$${receipt['amount']}'),
                  trailing: Text(receipt['type']),
                );
              },
            );
          }
        },
      ),
    );
  }
}