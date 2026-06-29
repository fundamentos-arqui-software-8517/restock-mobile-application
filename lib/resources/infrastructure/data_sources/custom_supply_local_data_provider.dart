import 'package:restock/resources/infrastructure/models/custom_supply_entity.dart';
import 'package:restock/resources/infrastructure/repositories/constants/resource_database_constants.dart';
import 'package:restock/shared/infrastructure/database/local_database.dart';
import 'package:sqflite/sqflite.dart';

class CustomSupplyLocalDataProvider {
  CustomSupplyLocalDataProvider({required this.appDatabase});

  final AppDatabase appDatabase;

  Future<List<CustomSupplyEntity>> getCustomSupplies() async {
    final db = await appDatabase.database;
    final result = await db.rawQuery(_customSupplyJoinQuery());

    return result.map(CustomSupplyEntity.fromMap).toList();
  }

  Future<List<CustomSupplyEntity>> getCustomSuppliesByAccountId(
    String accountId,
  ) async {
    final db = await appDatabase.database;
    final result = await db.rawQuery(
      '${_customSupplyJoinQuery()} WHERE cs.${ResourceDatabaseConstants.customSupplyAccountId} = ?',
      [accountId],
    );

    return result.map(CustomSupplyEntity.fromMap).toList();
  }

  Future<CustomSupplyEntity?> getCustomSupplyById(String customSupplyId) async {
    final db = await appDatabase.database;
    final result = await db.rawQuery(
      '${_customSupplyJoinQuery()} WHERE cs.${ResourceDatabaseConstants.customSupplyId} = ?',
      [customSupplyId],
    );

    if (result.isEmpty) return null;
    return CustomSupplyEntity.fromMap(result.first);
  }

  String _customSupplyJoinQuery() {
    final customSuppliesTable = ResourceDatabaseConstants.customSuppliesTable;
    final suppliesTable = ResourceDatabaseConstants.suppliesTable;

    return '''
      SELECT
        cs.${ResourceDatabaseConstants.customSupplyId},
        cs.${ResourceDatabaseConstants.customSupplyName},
        cs.${ResourceDatabaseConstants.customSupplyAccountId},
        cs.${ResourceDatabaseConstants.customSupplyDescription},
        cs.${ResourceDatabaseConstants.customSupplyUnitPriceAmount},
        cs.${ResourceDatabaseConstants.customSupplyUnitPriceCurrencyCode},
        cs.${ResourceDatabaseConstants.customSupplyMinimumStock},
        cs.${ResourceDatabaseConstants.customSupplyMaximumStock},
        cs.${ResourceDatabaseConstants.customSupplyUnitMeasurement},
        cs.${ResourceDatabaseConstants.customSupplyUnitMeasurementAbbreviation},
        cs.${ResourceDatabaseConstants.customSupplyPictureUrl},
        cs.${ResourceDatabaseConstants.customSupplyPicturePublicId},
        s.${ResourceDatabaseConstants.supplyId} AS supply_id,
        s.${ResourceDatabaseConstants.supplyName} AS supply_name,
        s.${ResourceDatabaseConstants.supplyDescription} AS supply_description,
        s.${ResourceDatabaseConstants.supplyCategory} AS supply_category,
        s.${ResourceDatabaseConstants.supplyIsPerishable} AS supply_is_perishable
      FROM $customSuppliesTable AS cs
      INNER JOIN $suppliesTable AS s
        ON cs.${ResourceDatabaseConstants.customSupplySupplyId}
          = s.${ResourceDatabaseConstants.supplyId}
    ''';
  }

  Future<void> saveCustomSupplies(
    List<CustomSupplyEntity> customSupplies,
  ) async {
    final db = await appDatabase.database;
    final batch = db.batch();

    for (final customSupply in customSupplies) {
      batch.insert(
        ResourceDatabaseConstants.suppliesTable,
        _supplyToMap(customSupply),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      batch.insert(
        ResourceDatabaseConstants.customSuppliesTable,
        customSupply.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> saveCustomSupply(CustomSupplyEntity customSupply) async {
    final db = await appDatabase.database;
    final batch = db.batch();

    batch.insert(
      ResourceDatabaseConstants.suppliesTable,
      _supplyToMap(customSupply),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    batch.insert(
      ResourceDatabaseConstants.customSuppliesTable,
      customSupply.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await batch.commit(noResult: true);
  }

  Future<void> clearCustomSupplies() async {
    final db = await appDatabase.database;
    await db.delete(ResourceDatabaseConstants.customSuppliesTable);
  }

  Map<String, dynamic> _supplyToMap(CustomSupplyEntity customSupply) {
    final supply = customSupply.supply;

    return {
      ResourceDatabaseConstants.supplyId: supply.supplyId,
      ResourceDatabaseConstants.supplyName: supply.name,
      ResourceDatabaseConstants.supplyDescription: supply.description,
      ResourceDatabaseConstants.supplyCategory: supply.category,
      ResourceDatabaseConstants.supplyIsPerishable: supply.isPerishable ? 1 : 0,
      ResourceDatabaseConstants.supplyIsCatalog: 0,
    };
  }
}
