import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/resources/domain/entities/register_custom_supply_command.dart';
import 'package:restock/resources/domain/entities/update_custom_supply_command.dart';

/// Repository interface for fetching custom supplies based on branch ID.
abstract class CustomSupplyRepository {
  /// Fetches a list of custom supplies associated with a specific branch ID.
  ///
  /// Returns a [Future] that resolves to a list of [CustomSupply] objects.
  Future<List<CustomSupply>> getCustomSuppliesByBranchId();

  /// Registers a custom supply.
  Future<CustomSupply> registerCustomSupply(
    RegisterCustomSupplyCommand command,
  );

  /// Updates a custom supply.
  Future<CustomSupply> updateCustomSupply(UpdateCustomSupplyCommand command);
}
