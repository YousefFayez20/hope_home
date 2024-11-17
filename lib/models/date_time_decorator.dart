import 'receipt.dart';
import 'package:intl/intl.dart'; // Optional: For date formatting

class DateTimeDecorator implements Receipt {
  final Receipt receipt;

  DateTimeDecorator(this.receipt);

  @override
  String generate() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Format the date and time (optional)
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    return "${receipt.generate()}\n\nGenerated on: $formattedDate";
  }

  @override
  Map<String, dynamic> toJson() {
    var baseJson = receipt.toJson();
    
    // Add the current date and time to the JSON
    baseJson.addAll({
      'footer': 'Generated on: ${DateTime.now().toIso8601String()}'
    });
    
    return baseJson;
  }
}
