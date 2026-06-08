import 'dart:io';

/// This file contains constants related to the API endpoints used in the application.
class ApiConstants {
  /// The base URL for Android and IOS Simulator (localhost).
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api/v1/';
    }
    return 'http://127.0.0.1:8080/api/v1/';
  }

  // IAM endpoints

  // Authentication
  static final String signIn = 'authentication/sign-in';

  // Resources endpoints

  /// Endpoints for custom supplies.
  static final String customSupplies = 'custom-supplies';

  static final String customSupplyByBranchId =
      'branches/{branchId}/custom-supplies';

  static String customSupplyById = 'custom-supplies/{customSupplyId}';

  // Endpoints for branches.
  static final String branches = 'branches';

  static String branchById = 'branches/{branchId}';

  static String branchStatus = 'branches/{branchId}/status';

  // Endpoints for supplies.

  static final String supplies = 'supplies';

  static final String suppliesCategories = 'supplies/categories';

  // Devices endpoints
  static final String devices = 'devices';
  static String deviceById = 'devices/{deviceId}';
  static String deviceSpecifications = 'devices/{deviceId}/specifications';
  static String deviceConfigBranch = 'devices/{deviceId}/configuration/branch';
  static String deviceConfigBatch = 'devices/{deviceId}/configuration/batch';
  static String deviceConfigThreshold = 'devices/{deviceId}/configuration/threshold';
  static String deviceConfigMeasurement = 'devices/{deviceId}/configuration/measurement';
  static String deviceStatus = 'devices/{deviceId}/status';
  static String deviceWithdrawnStock = 'devices/{deviceId}/withdrawn-stock';

  // Batches endpoints
  static final String batches = 'batches';

  // Device thresholds endpoints
  static final String deviceThresholds = 'device-thresholds';
  static String deviceThresholdById = 'device-thresholds/{thresholdId}';
}
