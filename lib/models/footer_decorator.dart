import 'receipt.dart';

class FooterDecorator implements Receipt {
  final Receipt receipt;

  FooterDecorator(this.receipt);

  @override
  String generate() {
    return "${receipt.generate()}\n\nOrphanage Management System\nContact us at: contact@orphanage.org";
  }

  @override
  Map<String, dynamic> toJson() {
    var baseJson = receipt.toJson();
    baseJson.addAll({
      'footer': 'Orphanage Management System\nContact us at: contact@orphanage.org'
    });
    return baseJson;
  }
}