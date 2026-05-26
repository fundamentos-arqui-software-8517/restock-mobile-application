import 'package:restock/resources/domain/repositories/custom_supply_repository.dart';
import 'package:restock/resources/infrastructure/data_sources/custom_supply_remote_data_provider.dart';
import 'package:restock/resources/domain/entities/custom_supply.dart';

class CustomSupplyRepositoryImpl implements CustomSupplyRepository {

  CustomSupplyRepositoryImpl({
    required this.customSupplyRemoteDataProvider,
  });

  final CustomSupplyRemoteDataProvider customSupplyRemoteDataProvider;

  @override
  Future<List<CustomSupply>> getCustomSuppliesByBranchId() async {
     try {
      final customSuppliesResponse = await customSupplyRemoteDataProvider.getCustomSuppliesByBranchId();
      return customSuppliesResponse.map((response) => response.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to fetch custom supplies: $e');
    }
  }
}
