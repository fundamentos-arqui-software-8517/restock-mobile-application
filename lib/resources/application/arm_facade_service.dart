import 'package:restock/resources/domain/repositories/custom_supply_repository.dart';
import 'package:restock/resources/domain/entities/custom_supply.dart';

class ArmFacadeService {

  const ArmFacadeService({
    required this.customSupplyRepository,
  });

  final CustomSupplyRepository customSupplyRepository;

  Future<List<CustomSupply>> getCustomSuppliesByBranchId() async {
    try {
      return await customSupplyRepository.getCustomSuppliesByBranchId();
    } catch (e) {
      throw Exception('Failed to fetch custom supplies: $e');
    }
  }
}