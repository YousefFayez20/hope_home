// lib/models/appreciation_decorator.dart

import 'receipt.dart';

class AppreciationDecorator implements Receipt {
  final Receipt receipt;

  AppreciationDecorator(this.receipt);

  @override
  String generate() {
    return "${receipt.generate()}\nThank you for your generous donation!";
  }
}
