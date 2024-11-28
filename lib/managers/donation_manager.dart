import '../observers/observable.dart';
import '../observers/observer.dart';
import '../data/database_helper.dart';

class DonationManager implements Observable {
  final DatabaseHelper databaseHelper;
  List<Observer> _observers = [];
  DonationManager(this.databaseHelper);


  Future<int> addDonation(String donorName, double amount, String donationType) async {
    try {
      final donationId = await databaseHelper.insertDonation(donorName, amount, donationType);
      notifyObservers();
      return donationId;
    } catch (e) {
      print("Error adding donation: $e");
      rethrow;
    }
  }


  Future<void> updateDonation(int id, String donorName, double amount, String donationType) async {
    try {
      await databaseHelper.updateDonation(id, donorName, amount, donationType);
      notifyObservers();
    } catch (e) {
      print("Error updating donation: $e");
      rethrow;
    }
  }


  Future<void> deleteDonation(int id) async {
    try {
      await databaseHelper.deleteDonation(id);
      notifyObservers();
    } catch (e) {
      print("Error deleting donation: $e");
      rethrow;
    }
  }


  Future<Map<String, dynamic>?> getDonationById(int id) async {
    try {
      final donation = await databaseHelper.getDonationById(id);
      return donation;
    } catch (e) {
      print("Error fetching donation by ID: $e");
      rethrow;
    }
  }


  @override
  void addObserver(Observer observer) {
    _observers.add(observer);
  }


  @override
  void removeObserver(Observer observer) {
    _observers.remove(observer);
  }


  @override
  void notifyObservers() {
    for (Observer observer in _observers) {
      observer.update();
    }
  }
}
