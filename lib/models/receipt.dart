// lib/models/receipt.dart

abstract class Receipt {
  String generate();
}

class BasicReceipt implements Receipt {
  final String donorName;
  final double amount;

  BasicReceipt(this.donorName, this.amount);

  @override
  String generate() {
    return "Receipt for $donorName\nDonation Amount: \$${amount.toStringAsFixed(2)}";
  }
}
