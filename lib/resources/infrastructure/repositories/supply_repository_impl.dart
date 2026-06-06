import 'package:restock/resources/domain/entities/supply.dart';
import 'package:restock/resources/domain/repositories/supply_repository.dart';
import 'package:restock/resources/infrastructure/data_sources/supply_remote_data_provider.dart';

/// Implementation of the SuppliesRepository that interacts with the SupplyRemoteDataProvider
class SupplyRepositoryImpl implements SupplyRepository {
  SupplyRepositoryImpl({required this.supplyRemoteDataProvider});

  final SupplyRemoteDataProvider supplyRemoteDataProvider;

  /// Fetches a list of supplies from the remote data provider
  @override
  Future<List<Supply>> fetchSupplies() async {
    try {
      final suppliesResponse = await supplyRemoteDataProvider.getSupplies();
      return suppliesResponse.map((response) => response.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to fetch supplies: $e');
    }
  }
}
