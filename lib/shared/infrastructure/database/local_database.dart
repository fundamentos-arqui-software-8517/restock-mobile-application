import 'package:path/path.dart';
import 'package:restock/resources/infrastructure/repositories/constants/resource_database_constants.dart';
import 'package:restock/shared/infrastructure/repositories/constants/database_constants.dart';
import 'package:sqflite/sqflite.dart';
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
      CREATE TABLE ${ResourceDatabaseConstants.branchesTable} (
        ${ResourceDatabaseConstants.branchId} TEXT PRIMARY KEY,
        ${ResourceDatabaseConstants.branchAccountId} TEXT NOT NULL,
        ${ResourceDatabaseConstants.branchName} TEXT NOT NULL,
        ${ResourceDatabaseConstants.branchAddress} TEXT NOT NULL,
        ${ResourceDatabaseConstants.branchCity} TEXT NOT NULL,
        ${ResourceDatabaseConstants.branchStateOrRegion} TEXT NOT NULL,
        ${ResourceDatabaseConstants.branchCountry} TEXT NOT NULL,
        ${ResourceDatabaseConstants.branchImageUrl} TEXT NOT NULL,
        ${ResourceDatabaseConstants.branchStatus} TEXT NOT NULL,
        ${ResourceDatabaseConstants.branchDescription} TEXT NOT NULL
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
        ALTER TABLE ${ResourceDatabaseConstants.suppliesTable}
        ADD COLUMN ${ResourceDatabaseConstants.supplyIsCatalog} INTEGER NOT NULL DEFAULT 0
      ''');
    }
  }

  Future<void> _createSuppliesTable(
    Database db, {
    bool ifNotExists = false,
  }) async {
    final existsClause = ifNotExists ? 'IF NOT EXISTS ' : '';

    await db.execute('''
      CREATE TABLE $existsClause${ResourceDatabaseConstants.suppliesTable} (
        ${ResourceDatabaseConstants.supplyId} TEXT PRIMARY KEY,
        ${ResourceDatabaseConstants.supplyName} TEXT NOT NULL,
        ${ResourceDatabaseConstants.supplyDescription} TEXT NOT NULL,
        ${ResourceDatabaseConstants.supplyCategory} TEXT NOT NULL,
        ${ResourceDatabaseConstants.supplyIsPerishable} INTEGER NOT NULL,
        ${ResourceDatabaseConstants.supplyIsCatalog} INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> _createCustomSuppliesTable(
    Database db, {
    bool ifNotExists = false,
  }) async {
    final existsClause = ifNotExists ? 'IF NOT EXISTS ' : '';

    await db.execute('''
      CREATE TABLE $existsClause${ResourceDatabaseConstants.customSuppliesTable} (
        ${ResourceDatabaseConstants.customSupplyId} TEXT PRIMARY KEY,
        ${ResourceDatabaseConstants.customSupplySupplyId} TEXT NOT NULL,
        ${ResourceDatabaseConstants.customSupplyName} TEXT NOT NULL,
        ${ResourceDatabaseConstants.customSupplyAccountId} TEXT NOT NULL,
        ${ResourceDatabaseConstants.customSupplyDescription} TEXT NOT NULL,
        ${ResourceDatabaseConstants.customSupplyUnitPriceAmount} TEXT NOT NULL,
        ${ResourceDatabaseConstants.customSupplyUnitPriceCurrencyCode} TEXT NOT NULL,
        ${ResourceDatabaseConstants.customSupplyMinimumStock} REAL NOT NULL,
        ${ResourceDatabaseConstants.customSupplyMaximumStock} REAL NOT NULL,
        ${ResourceDatabaseConstants.customSupplyUnitMeasurement} TEXT NOT NULL,
        ${ResourceDatabaseConstants.customSupplyUnitMeasurementAbbreviation} TEXT NOT NULL,
        ${ResourceDatabaseConstants.customSupplyPictureUrl} TEXT NOT NULL,
        ${ResourceDatabaseConstants.customSupplyPicturePublicId} TEXT NOT NULL,
        FOREIGN KEY (${ResourceDatabaseConstants.customSupplySupplyId})
          REFERENCES ${ResourceDatabaseConstants.suppliesTable} (${ResourceDatabaseConstants.supplyId})
          ON UPDATE CASCADE
          ON DELETE RESTRICT
      )
    ''');
  }
}
