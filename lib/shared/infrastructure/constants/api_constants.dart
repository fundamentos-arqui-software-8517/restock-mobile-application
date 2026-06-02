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
  static final String customSupplyByBranchId =
      'branches/{branchId}/custom-supplies';

  // Endpoints for branches.
  static final String branchesByAccountId = 'accounts/{accountId}/branches';

  static String branchById = 'branches/{branchId}';

  static String branchStatus = 'branches/{branchId}/status';
}
