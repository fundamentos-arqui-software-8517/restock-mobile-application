import 'package:restock/resources/infrastructure/models/custom_supply_entity.dart';
import 'package:restock/shared/infrastructure/constants/database_constants.dart';
import 'package:restock/shared/infrastructure/database/local_database.dart';
import 'package:sqflite/sqflite.dart';

class CustomSupplyLocalDataProvider {
  CustomSupplyLocalDataProvider({required this.appDatabase});

  final AppDatabase appDatabase;

  Future<List<CustomSupplyEntity>> getCustomSupplies() async {
    final db = await appDatabase.database;

    final customSuppliesTable = DatabaseConstants.customSuppliesTable;
    final suppliesTable = DatabaseConstants.suppliesTable;

    final result = await db.rawQuery('''
      SELECT
        cs.${DatabaseConstants.customSupplyId},
        cs.${DatabaseConstants.customSupplyName},
        cs.${DatabaseConstants.customSupplyAccountId},
        cs.${DatabaseConstants.customSupplyDescription},
        cs.${DatabaseConstants.customSupplyUnitPriceAmount},
        cs.${DatabaseConstants.customSupplyUnitPriceCurrencyCode},
        cs.${DatabaseConstants.customSupplyMinimumStock},
        cs.${DatabaseConstants.customSupplyMaximumStock},
        cs.${DatabaseConstants.customSupplyUnitMeasurement},
        cs.${DatabaseConstants.customSupplyUnitMeasurementAbbreviation},
        cs.${DatabaseConstants.customSupplyPictureUrl},
        cs.${DatabaseConstants.customSupplyPicturePublicId},
        s.${DatabaseConstants.supplyId} AS supply_id,
        s.${DatabaseConstants.supplyName} AS supply_name,
        s.${DatabaseConstants.supplyDescription} AS supply_description,
        s.${DatabaseConstants.supplyCategory} AS supply_category,
        s.${DatabaseConstants.supplyIsPerishable} AS supply_is_perishable
      FROM $customSuppliesTable AS cs
      INNER JOIN $suppliesTable AS s
        ON cs.${DatabaseConstants.customSupplySupplyId}
          = s.${DatabaseConstants.supplyId}
    ''');

    return result.map(CustomSupplyEntity.fromMap).toList();
  }

  Future<void> saveCustomSupplies(
    List<CustomSupplyEntity> customSupplies,
  ) async {
    final db = await appDatabase.database;
    final batch = db.batch();

    for (final customSupply in customSupplies) {
      batch.insert(
        DatabaseConstants.suppliesTable,
        _supplyToMap(customSupply),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      batch.insert(
        DatabaseConstants.customSuppliesTable,
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
      DatabaseConstants.suppliesTable,
      _supplyToMap(customSupply),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    batch.insert(
      DatabaseConstants.customSuppliesTable,
      customSupply.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await batch.commit(noResult: true);
  }

  Future<void> clearCustomSupplies() async {
    final db = await appDatabase.database;
    await db.delete(DatabaseConstants.customSuppliesTable);
  }

  Map<String, dynamic> _supplyToMap(CustomSupplyEntity customSupply) {
    final supply = customSupply.supply;

    return {
      DatabaseConstants.supplyId: supply.supplyId,
      DatabaseConstants.supplyName: supply.name,
      DatabaseConstants.supplyDescription: supply.description,
      DatabaseConstants.supplyCategory: supply.category,
      DatabaseConstants.supplyIsPerishable: supply.isPerishable ? 1 : 0,
      DatabaseConstants.supplyIsCatalog: 0,
    };
  }
}
