import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:restock/shared/infrastructure/constants/database_constants.dart';

/// A singleton class that manages the local database connection using sqflite.
/// This class ensures that only one instance of the database is created and provides a method to access the database instance.
class AppDatabase {
  AppDatabase._();

  // Singleton instance of the AppDatabase class.
  static final AppDatabase _instance = AppDatabase._();

  /// Initializes the database by creating a connection to the local database file.
  factory AppDatabase() => _instance;

  // Private variable to hold the database instance.
  Database? _database;

  /// Initializes the database by creating a connection to the local database file.
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database by creating a connection to the local database file and setting up the necessary tables.
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), DatabaseConstants.databaseName);
    
    return await openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE ${DatabaseConstants.branchesTable} (
      ${DatabaseConstants.branchId} TEXT PRIMARY KEY,
      ${DatabaseConstants.branchAccountId} TEXT NOT NULL,
      ${DatabaseConstants.branchName} TEXT NOT NULL,
      ${DatabaseConstants.branchAddress} TEXT NOT NULL,
      ${DatabaseConstants.branchCity} TEXT NOT NULL,
      ${DatabaseConstants.branchStateOrRegion} TEXT NOT NULL,
      ${DatabaseConstants.branchCountry} TEXT NOT NULL,
      ${DatabaseConstants.branchImageUrl} TEXT NOT NULL,
      ${DatabaseConstants.branchStatus} TEXT NOT NULL,
      ${DatabaseConstants.branchDescription} TEXT NOT NULL
    )
  ''');
  }
}