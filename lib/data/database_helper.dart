import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('donations.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE donations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        donorName TEXT NOT NULL,
        amount REAL NOT NULL,
        donationType TEXT NOT NULL
      )
    ''');

    if (version >= 2) {
      await db.execute('''
        CREATE TABLE receipts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          receiptData TEXT NOT NULL
        )
      ''');
    }
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE receipts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          receiptData TEXT NOT NULL
        )
      ''');
    }
  }

  // ---------------- Donation Methods ----------------

  /// Insert a new donation and return its ID
  Future<int> insertDonation(String donorName, double amount, String donationType) async {
    try {
      final db = await database;
      return await db.insert('donations', {
        'donorName': donorName,
        'amount': amount,
        'donationType': donationType,
      });
    } catch (e) {
      print("Error inserting donation: $e");
      rethrow;
    }
  }

  /// Update an existing donation
  Future<void> updateDonation(int id, String donorName, double amount, String donationType) async {
    try {
      final db = await database;
      await db.update(
        'donations',
        {
          'donorName': donorName,
          'amount': amount,
          'donationType': donationType,
        },
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error updating donation: $e");
      rethrow;
    }
  }

  /// Delete a donation by ID
  Future<void> deleteDonation(int id) async {
    try {
      final db = await database;
      await db.delete(
        'donations',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting donation: $e");
      rethrow;
    }
  }

  /// Fetch a specific donation by ID
  Future<Map<String, dynamic>?> getDonationById(int id) async {
    try {
      final db = await database;
      final result = await db.query(
        'donations',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print("Error fetching donation by ID: $e");
      rethrow;
    }
  }

  /// Fetch all donations
  Future<List<Map<String, dynamic>>> getDonations() async {
    try {
      final db = await database;
      return await db.query('donations', orderBy: 'id DESC');
    } catch (e) {
      print("Error fetching donations: $e");
      rethrow;
    }
  }

  // ---------------- Receipt Methods ----------------

  /// Insert a new receipt
  Future<int> insertReceipt(Map<String, dynamic> receiptData) async {
    try {
      final db = await database;
      return await db.insert('receipts', {'receiptData': jsonEncode(receiptData)});
    } catch (e) {
      print("Error inserting receipt: $e");
      rethrow;
    }
  }

  /// Fetch all receipts
  Future<List<Map<String, dynamic>>> getReceipts() async {
    try {
      final db = await database;
      final results = await db.query('receipts');
      return results
          .map((map) => jsonDecode(map['receiptData'] as String) as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching receipts: $e");
      rethrow;
    }
  }

  /// Delete a receipt by ID
  Future<void> deleteReceipt(int id) async {
    try {
      final db = await database;
      await db.delete(
        'receipts',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting receipt: $e");
      rethrow;
    }
  }

  // ---------------- Database Utility Methods ----------------

  /// Delete the entire database (useful for debugging)
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'donations.db');

    final db = await database;
    await db.close(); // Close the resolved database instance

    await sqflite.deleteDatabase(path); // Delete the database file

    _database = null; // Reset the database instance
  }

}
