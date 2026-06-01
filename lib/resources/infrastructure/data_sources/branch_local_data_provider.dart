import 'package:restock/resources/infrastructure/models/branch_entity.dart';
import 'package:restock/shared/infrastructure/constants/database_constants.dart';
import 'package:restock/shared/infrastructure/database/local_database.dart';
import 'package:sqflite/sqflite.dart';

class BranchLocalDataProvider {
  BranchLocalDataProvider({required this.appDatabase});

  final AppDatabase appDatabase;

  Future<List<BranchEntity>> getBranches() async {
    final db = await appDatabase.database;
    final result = await db.query(DatabaseConstants.branchesTable);
    return result.map(BranchEntity.fromMap).toList();
  }

  Future<BranchEntity?> getBranchById(String branchId) async {
    final db = await appDatabase.database;
    final result = await db.query(
      DatabaseConstants.branchesTable,
      where: '${DatabaseConstants.branchId} = ?',
      whereArgs: [branchId],
    );
    if (result.isEmpty) return null;
    return BranchEntity.fromMap(result.first);
  }

  Future<void> saveBranches(List<BranchEntity> branches) async {
    final db = await appDatabase.database;
    final batch = db.batch();
    for (final branch in branches) {
      batch.insert(
        DatabaseConstants.branchesTable,
        branch.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> saveBranch(BranchEntity branch) async {
    final db = await appDatabase.database;
    await db.insert(
      DatabaseConstants.branchesTable,
      branch.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteBranch(String branchId) async {
    final db = await appDatabase.database;
    await db.delete(
      DatabaseConstants.branchesTable,
      where: '${DatabaseConstants.branchId} = ?',
      whereArgs: [branchId],
    );
  }

  Future<void> clearBranches() async {
    final db = await appDatabase.database;
    await db.delete(DatabaseConstants.branchesTable);
  }
}
