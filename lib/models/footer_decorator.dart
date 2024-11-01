// lib/models/footer_decorator.dart

import 'receipt.dart';

class FooterDecorator implements Receipt {
  final Receipt receipt;

  FooterDecorator(this.receipt);

  @override
  String generate() {
    return "${receipt.generate()}\n\nOrphanage Management System\nContact us at: contact@orphanage.org";
  }
}
