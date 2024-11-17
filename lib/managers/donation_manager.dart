// lib/managers/donation_manager.dart

import '../observers/observable.dart';
import '../observers/observer.dart';
import '../data/database_helper.dart';

class DonationManager implements Observable {
  final DatabaseHelper databaseHelper; // Add this line
  List<Observer> _observers = [];

  DonationManager(
      this.databaseHelper); // Constructor to initialize databaseHelper

  // Method to add a new donation and notify observers
  Future<void> addDonation(String donorName, double amount,
      String donationType) async {
    await databaseHelper.insertDonation(donorName, amount, donationType);
    notifyObservers();
  }

  // Method to update an existing donation and notify observers
  Future<void> updateDonation(int id, String donorName, double amount,
      String donationType) async {
    await databaseHelper.updateDonation(id, donorName, amount, donationType);
    notifyObservers();
  }

  // Method to delete a donation and notify observers
  Future<void> deleteDonation(int id) async {
    await databaseHelper.deleteDonation(id);
    notifyObservers();
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