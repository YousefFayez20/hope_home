import 'receipt.dart';

class TaxInfoDecorator implements Receipt {
  final Receipt receipt;

  TaxInfoDecorator(this.receipt);

  @override
  String generate() {
    return "${receipt.generate()}\nEligible for Tax Deduction: Yes";
  }

  @override
  Map<String, dynamic> toJson() {
    var baseJson = receipt.toJson();
    baseJson.addAll({'taxInfo': 'Eligible for Tax Deduction: Yes'});
    return baseJson;
  }
}