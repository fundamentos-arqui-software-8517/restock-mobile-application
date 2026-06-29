/// Constants for the resources API endpoints.
class ResourcesApiConstants {
  /// Endpoints for custom supplies.
  static final String customSupplies = 'custom-supplies';

  static final String customSupplyByBranchId =
      'branches/{branchId}/custom-supplies';

  static String customSupplyById = 'custom-supplies/{customSupplyId}';

  /// Endpoints for branches.
  static final String branches = 'branches';

  static String branchById = 'branches/{branchId}';

  static String branchStatus = 'branches/{branchId}/status';

  /// Endpoints for supplies.

  static final String supplies = 'supplies';

  static final String suppliesCategories = 'supplies/categories';

  /// Endpoints for batches.
  static final String batches = 'batches';

  static String batchById = 'batches/{batchId}';

  static String transferBatchById = 'batches/{batchId}/transfer';
}
