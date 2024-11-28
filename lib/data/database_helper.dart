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
        donorName TEXT,
        amount REAL,
        donationType TEXT
      )
    ''');

    if (version >= 2) {
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

  Future<List<Map<String, dynamic>>> getDonations() async {
    try {
      final db = await database;
      return await db.query('donations', orderBy: 'id DESC');
    } catch (e) {
      print("Error fetching donations: $e");
      rethrow;
    }
  }

  Future<void> insertReceipt(Map<String, dynamic> receiptData) async {
    final db = await database;
    await db.insert('receipts', {'receiptData': jsonEncode(receiptData)});
  }


  Future<List<Map<String, dynamic>>> getReceipts() async {
    final db = await database;
    final results = await db.query('receipts');
    return results
        .map((map) => jsonDecode(map['receiptData'] as String) as Map<String, dynamic>)
        .toList();
  }

  Future<void> deleteReceipt(int id) async {
    final db = await database;
    await db.delete(
      'receipts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
