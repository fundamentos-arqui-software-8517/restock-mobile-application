import 'package:restock/arm/domain/entities/custom_supply.dart';

abstract class CustomSupplyRepository {
  
  Future<List<CustomSupply>> getCustomSuppliesByBranchId();
}