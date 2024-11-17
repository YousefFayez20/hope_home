import 'receipt.dart';

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