/// This file contains constants related to the API endpoints used in the application.
class ApiConstants {

  /// The base URL for the API endpoints.
  static final String baseUrl = 'http://10.0.2.2:8080/api/v1/';

  /// The endpoint for fetching custom supplies by branch ID.
  static final String customSupplyByBranchId = 'branches/{branchId}/custom-supplies';
}