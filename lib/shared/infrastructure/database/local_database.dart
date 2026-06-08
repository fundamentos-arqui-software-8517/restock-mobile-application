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
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// Creates the necessary tables in the database when it is first created.
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

    await _createSuppliesTable(db);
    await _createCustomSuppliesTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createSuppliesTable(db, ifNotExists: true);
      await _createCustomSuppliesTable(db, ifNotExists: true);
    }

    if (oldVersion >= 2 && oldVersion < 3) {
      await db.execute('''
        ALTER TABLE ${DatabaseConstants.suppliesTable}
        ADD COLUMN ${DatabaseConstants.supplyIsCatalog} INTEGER NOT NULL DEFAULT 0
      ''');
    }
  }

  Future<void> _createSuppliesTable(
    Database db, {
    bool ifNotExists = false,
  }) async {
    final existsClause = ifNotExists ? 'IF NOT EXISTS ' : '';

    await db.execute('''
      CREATE TABLE $existsClause${DatabaseConstants.suppliesTable} (
        ${DatabaseConstants.supplyId} TEXT PRIMARY KEY,
        ${DatabaseConstants.supplyName} TEXT NOT NULL,
        ${DatabaseConstants.supplyDescription} TEXT NOT NULL,
        ${DatabaseConstants.supplyCategory} TEXT NOT NULL,
        ${DatabaseConstants.supplyIsPerishable} INTEGER NOT NULL,
        ${DatabaseConstants.supplyIsCatalog} INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> _createCustomSuppliesTable(
    Database db, {
    bool ifNotExists = false,
  }) async {
    final existsClause = ifNotExists ? 'IF NOT EXISTS ' : '';

    await db.execute('''
      CREATE TABLE $existsClause${DatabaseConstants.customSuppliesTable} (
        ${DatabaseConstants.customSupplyId} TEXT PRIMARY KEY,
        ${DatabaseConstants.customSupplySupplyId} TEXT NOT NULL,
        ${DatabaseConstants.customSupplyName} TEXT NOT NULL,
        ${DatabaseConstants.customSupplyAccountId} TEXT NOT NULL,
        ${DatabaseConstants.customSupplyDescription} TEXT NOT NULL,
        ${DatabaseConstants.customSupplyUnitPriceAmount} TEXT NOT NULL,
        ${DatabaseConstants.customSupplyUnitPriceCurrencyCode} TEXT NOT NULL,
        ${DatabaseConstants.customSupplyMinimumStock} REAL NOT NULL,
        ${DatabaseConstants.customSupplyMaximumStock} REAL NOT NULL,
        ${DatabaseConstants.customSupplyUnitMeasurement} TEXT NOT NULL,
        ${DatabaseConstants.customSupplyUnitMeasurementAbbreviation} TEXT NOT NULL,
        ${DatabaseConstants.customSupplyPictureUrl} TEXT NOT NULL,
        ${DatabaseConstants.customSupplyPicturePublicId} TEXT NOT NULL,
        FOREIGN KEY (${DatabaseConstants.customSupplySupplyId})
          REFERENCES ${DatabaseConstants.suppliesTable} (${DatabaseConstants.supplyId})
          ON UPDATE CASCADE
          ON DELETE RESTRICT
      )
    ''');
  }
}
