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
    _loadReceipts();
  }

  void _loadReceipts() {
    setState(() {
      receipts = DatabaseHelper.instance.getReceipts();
    });
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
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load receipts: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No receipts found.'),
            );
          } else {
            return ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final receipt = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text('Receipt for ${receipt['donorName'] ?? 'Unknown Donor'}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Amount: \$${receipt['amount']}'),
                        Text('Type: ${receipt['type'] ?? 'N/A'}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteReceipt(receipt['id']),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _deleteReceipt(int id) async {
    await DatabaseHelper.instance.deleteReceipt(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Receipt deleted successfully.')),
    );
    _loadReceipts(); // Reload the receipts list
  }
}
