import 'receipt.dart';

// Appreciation Decorator: Adds a thank-you note to the receipt.
class AppreciationDecorator implements Receipt {
  final Receipt receipt;

  AppreciationDecorator(this.receipt);

  @override
  String generate() {
    return "${receipt.generate()}\nThank you for your generous donation!";
  }

  @override
  Map<String, dynamic> toJson() {
    var baseJson = receipt.toJson();
    baseJson.addAll({'appreciation': 'Thank you for your generous donation!'});
    return baseJson;
  }
}

// Receipt Formatting Decorator: Formats the receipt for different output styles (e.g., plain text, HTML).
class HtmlFormatterDecorator implements Receipt {
  final Receipt receipt;

  HtmlFormatterDecorator(this.receipt);

  @override
  String generate() {
    return "<html><body><p>${receipt.generate().replaceAll('\n', '<br>')}</p></body></html>";
  }

  @override
  Map<String, dynamic> toJson() {
    return receipt.toJson(); // No formatting change needed for JSON
  }
}

// Digital Signature Decorator: Adds a digital signature to the receipt.
class SignatureDecorator implements Receipt {
  final Receipt receipt;
  final String signature;

  SignatureDecorator(this.receipt, this.signature);

  @override
  String generate() {
    return "${receipt.generate()}\nSignature: $signature";
  }

  @override
  Map<String, dynamic> toJson() {
    var baseJson = receipt.toJson();
    baseJson.addAll({'signature': signature});
    return baseJson;
  }
}

// Multi-Currency Support Decorator: Displays the amount in multiple currencies.
class CurrencyDecorator implements Receipt {
  final Receipt receipt;
  final String currencySymbol;
  final double exchangeRate; // Exchange rate for the currency

  CurrencyDecorator(this.receipt, this.currencySymbol, this.exchangeRate);

  @override
  String generate() {
    // Fetch the amount from receipt and ensure it is a double
    double originalAmount = (receipt.toJson()['amount'] as num).toDouble();
    double convertedAmount = originalAmount * exchangeRate;
    return "${receipt.generate()}\nAmount in $currencySymbol: $currencySymbol${convertedAmount.toStringAsFixed(2)}";
  }

  @override
  Map<String, dynamic> toJson() {
    var baseJson = receipt.toJson();
    double originalAmount = (baseJson['amount'] as num).toDouble();
    double convertedAmount = originalAmount * exchangeRate;
    baseJson.addAll({
      'currency': currencySymbol,
      'exchange_rate': exchangeRate,
      'converted_amount': convertedAmount,
    });
    return baseJson;
  }
}

// Example Usage
void main() {
  // Base Receipt
  Receipt basicReceipt = BasicReceipt("John Doe", 100.00); // Updated instantiation with positional parameters

  // Add Appreciation
  basicReceipt = AppreciationDecorator(basicReceipt);

  // Add Digital Signature
  basicReceipt = SignatureDecorator(basicReceipt, "John Doe Digital Signature");

  // Add Multi-Currency Support (e.g., convert to EUR at an exchange rate of 0.85)
  basicReceipt = CurrencyDecorator(basicReceipt, "€", 0.85);

  // Format the Receipt as HTML
  basicReceipt = HtmlFormatterDecorator(basicReceipt);

  // Generate and Print the Receipt
  print(basicReceipt.generate());

  // Convert Receipt to JSON
  print(basicReceipt.toJson());
}