import 'package:restock/resources/infrastructure/models/branch_entity.dart';
import 'package:restock/resources/infrastructure/repositories/constants/resource_database_constants.dart';
import 'package:restock/shared/infrastructure/database/local_database.dart';
import 'package:sqflite/sqflite.dart';

/// Handles local data operations for Branch entities using SQLite.
class BranchLocalDataProvider {

  /// Initializes the BranchLocalDataProvider with the provided AppDatabase instance.
  BranchLocalDataProvider({required this.appDatabase});

  /// The AppDatabase instance used for database operations.
  final AppDatabase appDatabase;

  /// Retrieves all Branch entities from the local database.
  Future<List<BranchEntity>> getBranches() async {
    final db = await appDatabase.database;
    final result = await db.query(ResourceDatabaseConstants.branchesTable);
    return result.map(BranchEntity.fromMap).toList();
  }

  /// Retrieves a Branch entity by its ID from the local database.
  Future<BranchEntity?> getBranchById(String branchId) async {
    final db = await appDatabase.database;
    final result = await db.query(
      ResourceDatabaseConstants.branchesTable,
      where: '${ResourceDatabaseConstants.branchId} = ?',
      whereArgs: [branchId],
    );
    if (result.isEmpty) return null;
    return BranchEntity.fromMap(result.first);
  }

  /// Saves a list of Branch entities to the local database, replacing existing entries with the same ID.
  Future<void> saveBranches(List<BranchEntity> branches) async {
    final db = await appDatabase.database;
    final batch = db.batch();
    for (final branch in branches) {
      batch.insert(
        ResourceDatabaseConstants.branchesTable,
        branch.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// Saves a single Branch entity to the local database, replacing existing entry with the same ID.
  Future<void> saveBranch(BranchEntity branch) async {
    final db = await appDatabase.database;
    await db.insert(
      ResourceDatabaseConstants.branchesTable,
      branch.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Deletes a Branch entity by its ID from the local database.
  Future<void> deleteBranch(String branchId) async {
    final db = await appDatabase.database;
    await db.delete(
      ResourceDatabaseConstants.branchesTable,
      where: '${ResourceDatabaseConstants.branchId} = ?',
      whereArgs: [branchId],
    );
  }

  /// Clears all Branch entities from the local database.
  Future<void> clearBranches() async {
    final db = await appDatabase.database;
    await db.delete(ResourceDatabaseConstants.branchesTable);
  }
}
