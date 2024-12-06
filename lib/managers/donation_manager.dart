import '../observers/observable.dart';
import '../observers/observer.dart';
import '../data/database_helper.dart';

/// Manager class for handling donation-related operations
class DonationManager implements Observable {
  final DatabaseHelper databaseHelper;
  final List<Observer> _observers = [];

  DonationManager(this.databaseHelper);

  /// Adds a new donation and notifies observers
  /// Returns the ID of the added donation
  Future<int> addDonation(String donorName, double amount, String donationType) async {
    try {
      final donationId = await databaseHelper.insertDonation(donorName, amount, donationType);
      notifyObservers(); // Notify observers after addition
      return donationId;
    } catch (e) {
      print("Error adding donation: $e");
      rethrow;
    }
  }

  /// Updates an existing donation and notifies observers
  Future<void> updateDonation(int id, String donorName, double amount, String donationType) async {
    try {
      await databaseHelper.updateDonation(id, donorName, amount, donationType);
      notifyObservers(); // Notify observers after update
    } catch (e) {
      print("Error updating donation: $e");
      rethrow;
    }
  }

  /// Deletes a donation and notifies observers
  Future<void> deleteDonation(int id) async {
    try {
      await databaseHelper.deleteDonation(id);
      notifyObservers(); // Notify observers after deletion
    } catch (e) {
      print("Error deleting donation: $e");
      rethrow;
    }
  }

  /// Retrieves a specific donation by ID
  Future<Map<String, dynamic>?> getDonationById(int id) async {
    try {
      final donation = await databaseHelper.getDonationById(id);
      return donation;
    } catch (e) {
      print("Error fetching donation by ID: $e");
      rethrow;
    }
  }

  /// Retrieves all donations
  Future<List<Map<String, dynamic>>> getAllDonations() async {
    try {
      final donations = await databaseHelper.getDonations();
      return donations;
    } catch (e) {
      print("Error fetching all donations: $e");
      rethrow;
    }
  }

  // -------------------- Observer Management --------------------

  /// Adds an observer to the list
  @override
  void addObserver(Observer observer) {
    if (!_observers.contains(observer)) {
      _observers.add(observer);
    }
  }

  /// Removes an observer from the list
  @override
  void removeObserver(Observer observer) {
    _observers.remove(observer);
  }

  /// Notifies all observers about changes
  @override
  void notifyObservers() {
    for (Observer observer in _observers) {
      try {
        observer.update();
      } catch (e) {
        print("Error notifying observer: $e");
      }
    }
  }
}
