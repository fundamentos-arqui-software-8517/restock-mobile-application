import 'package:restock/resources/infrastructure/models/supply_entity.dart';
import 'package:restock/resources/infrastructure/repositories/constants/resource_database_constants.dart';
import 'package:restock/shared/infrastructure/database/local_database.dart';
import 'package:sqflite/sqflite.dart';

class SupplyLocalDataProvider {
  SupplyLocalDataProvider({required this.appDatabase});

  final AppDatabase appDatabase;

  Future<List<SupplyEntity>> getSupplies() async {
    final db = await appDatabase.database;
    final result = await db.query(
      ResourceDatabaseConstants.suppliesTable,
      where: '${ResourceDatabaseConstants.supplyIsCatalog} = ?',
      whereArgs: [1],
    );
    return result.map(SupplyEntity.fromMap).toList();
  }

  Future<SupplyEntity?> getSupplyById(String supplyId) async {
    final db = await appDatabase.database;
    final result = await db.query(
      ResourceDatabaseConstants.suppliesTable,
      where: '${ResourceDatabaseConstants.supplyId} = ?',
      whereArgs: [supplyId],
    );

    if (result.isEmpty) return null;
    return SupplyEntity.fromMap(result.first);
  }

  Future<void> saveSupplies(List<SupplyEntity> supplies) async {
    final db = await appDatabase.database;
    final batch = db.batch();

    for (final supply in supplies) {
      batch.insert(
        ResourceDatabaseConstants.suppliesTable,
        supply.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> saveSupply(SupplyEntity supply) async {
    final db = await appDatabase.database;
    await db.insert(
      ResourceDatabaseConstants.suppliesTable,
      supply.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> clearSupplies() async {
    final db = await appDatabase.database;
    await db.delete(ResourceDatabaseConstants.suppliesTable);
  }
}
