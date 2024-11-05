import 'dart:convert';

abstract class Receipt {
  String generate();
  Map<String, dynamic> toJson();
}

class BasicReceipt implements Receipt {
  final String donorName;
  final double amount;

  BasicReceipt(this.donorName, this.amount);

  @override
  String generate() {
    return "Receipt for $donorName\nDonation Amount: \$${amount.toStringAsFixed(2)}";
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'BasicReceipt',
      'donorName': donorName,
      'amount': amount,
    };
  }
}