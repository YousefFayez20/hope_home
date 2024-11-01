// lib/models/tax_info_decorator.dart

import 'receipt.dart';

class TaxInfoDecorator implements Receipt {
  final Receipt receipt;

  TaxInfoDecorator(this.receipt);

  @override
  String generate() {
    return "${receipt.generate()}\nEligible for Tax Deduction: Yes";
  }
}
