/// This file contains constants related to the database configuration, such as the database name and version.
class DatabaseConstants {

  /// The name of the database file.
  static const String databaseName = 'restock.db';

  /// The version of the database schema. Increment this number when making changes to the database structure.
  static const int databaseVersion = 1;

  // Branches table
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
}