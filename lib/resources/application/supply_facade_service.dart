import 'package:restock/resources/domain/entities/supply.dart';
import 'package:restock/resources/domain/repositories/supply_repository.dart';

/// Facade service to manage supply-related operations
class SupplyFacadeService {
  const SupplyFacadeService({required this.supplyRepository});

  final SupplyRepository supplyRepository;

  /// Fetches a list of supplies
  Future<List<Supply>> getSupplies() async {
    try {
      return await supplyRepository.fetchSupplies();
    } catch (e) {
      throw Exception('Failed to fetch supplies: $e');
    }
  }

}
