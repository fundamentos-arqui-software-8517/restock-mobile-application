import 'package:restock/resources/domain/repositories/custom_supply_repository.dart';
import 'package:restock/resources/domain/entities/custom_supply.dart';

/// Facade service to manage resource-related operations
class CustomSupplyFacadeService {
  /// Constructor for the CustomSupplyFacadeService
  const CustomSupplyFacadeService({required this.customSupplyRepository});

  /// Repository for managing custom supply data
  final CustomSupplyRepository customSupplyRepository;

  /// Fetches a list of custom supplies for the current branch
  Future<List<CustomSupply>> getCustomSuppliesByBranchId() async {
    try {
      return await customSupplyRepository.getCustomSuppliesByBranchId();
    } catch (e) {
      throw Exception('Failed to fetch custom supplies: $e');
    }
  }
}
