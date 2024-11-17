import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert'; // Necessary for JSON operations

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
      version: 2, // Incremented version for schema changes
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE donations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        donorName TEXT,
        amount REAL,
        donationType TEXT
      )
    ''');

    if (version >= 2) {
      // Create receipts table if the version is 2 or higher
      await db.execute('''
        CREATE TABLE receipts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          receiptData TEXT
        )
      ''');
    }
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE receipts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          receiptData TEXT
        )
      ''');
    }
  }

  // Receipts Methods
  Future<void> insertReceipt(Map<String, dynamic> receiptData) async {
    final db = await database;
    await db.insert('receipts', {'receiptData': jsonEncode(receiptData)});
  }

  Future<List<Map<String, dynamic>>> getReceipts() async {
    final db = await database;
    final results = await db.query('receipts');
    return results.map((map) => jsonDecode(map['receiptData'] as String) as Map<String, dynamic>).toList();
  }

  Future<void> deleteReceipt(int id) async {
    final db = await database;
    await db.delete(
      'receipts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Existing Donation Methods
  // Insert new donation
  Future<void> insertDonation(String donorName, double amount, String donationType) async {
    final db = await database;
    await db.insert('donations', {
      'donorName': donorName,
      'amount': amount,
      'donationType': donationType,
    });
  }

  // Update a donation
  Future<void> updateDonation(int id, String donorName, double amount, String donationType) async {
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
  }

  // Delete a donation
  Future<void> deleteDonation(int id) async {
    final db = await database;
    await db.delete('donations', where: 'id = ?', whereArgs: [id]);
  }

  // Get all donations
  Future<List<Map<String, dynamic>>> getDonations() async {
    final db = await database;
    return await db.query('donations', orderBy: 'id DESC');
  }
}