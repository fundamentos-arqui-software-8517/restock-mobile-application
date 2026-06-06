/// This file contains constants related to the database configuration, such as the database name and version.
class DatabaseConstants {

  /// The name of the database file.
  static const String databaseName = 'restock.db';

  /// The version of the database schema. Increment this number when making changes to the database structure.
  static const int databaseVersion = 1;

  /// Branches table
  static const String branchesTable = 'branches';

  static const String branchId = 'branch_id';
  static const String branchAccountId = 'account_id';
  static const String branchName = 'name';
  static const String branchAddress = 'address';
  static const String branchCity = 'city';
  static const String branchStateOrRegion = 'state_or_region';
  static const String branchCountry = 'country';
  static const String branchImageUrl = 'image_url';
  static const String branchStatus = 'status';
  static const String branchDescription = 'description';

  /// Supplies table
  static const String suppliesTable = 'supplies';

  static const String supplyId = 'supply_id';
  static const String supplyName = 'name';
  static const String supplyDescription = 'description';
  static const String supplyCategory = 'category';
  static const String supplyIsPerishable = 'is_perishable';

  /// Custom Supplies table
  static const String customSuppliesTable = 'custom_supplies';

  static const String customSupplyId = 'custom_supply_id';
  static const String customSupplyName = 'name';
  static const String customSupplyAccountId = 'account_id';
  static const String customSupplyDescription = 'description';
  static const String customSupplyUnitPriceAmount = 'unit_price_amount';
  static const String customSupplyUnitPriceCurrencyCode = 'unit_price_currency_code';
  static const String customSupplyMinimumStock = 'minimum_stock';
  static const String customSupplyMaximumStock = 'maximum_stock';
  static const String customSupplyUnitMeasurement = 'unit_measurement';
  static const String customSupplyUnitMeasurementAbbreviation = 'unit_measurement_abbreviation';
  static const String customSupplyPictureUrl = 'picture_url';

  /// Foreign keys
  static const String supplyIdForeignKey = 'supply_id';
}