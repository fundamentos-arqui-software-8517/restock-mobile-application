import 'package:restock/resources/domain/entities/supply.dart';

/// SuppliesRepository is an abstract class that defines the contract for fetching supplies data.
abstract class SupplyRepository {

  /// Fetches a list of supplies from the data source.
  Future<List<Supply>> fetchSupplies();
}