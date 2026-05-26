import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// A singleton class that manages the local database connection using sqflite.
/// This class ensures that only one instance of the database is created and provides a method to access the database instance.
class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Database? _database;

  /// Initializes the database by creating a connection to the local database file.
  factory AppDatabase() {
    return _instance;
  }

  /// Initializes the database by creating a connection to the local database file.
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database! as Database;
  }

  /// Initializes the database by creating a connection to the local database file and setting up the necessary tables.
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'restock.db');
    return await openDatabase(
      path,
      version: 1
    );
  }
}