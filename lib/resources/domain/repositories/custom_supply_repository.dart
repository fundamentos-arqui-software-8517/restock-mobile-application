import 'package:restock/resources/domain/entities/custom_supply.dart';

/// Repository interface for fetching custom supplies based on branch ID.
abstract class CustomSupplyRepository {
  
  /// Fetches a list of custom supplies associated with a specific branch ID.
  /// 
  /// Returns a [Future] that resolves to a list of [CustomSupply] objects.
  Future<List<CustomSupply>> getCustomSuppliesByBranchId();
}