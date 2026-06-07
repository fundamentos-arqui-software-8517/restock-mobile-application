import 'package:restock/resources/domain/entities/supply.dart';
import 'package:restock/resources/domain/repositories/supply_repository.dart';
import 'package:restock/resources/infrastructure/data_sources/supply_local_data_provider.dart';
import 'package:restock/resources/infrastructure/data_sources/supply_remote_data_provider.dart';
import 'package:restock/resources/infrastructure/models/supply_entity.dart';

/// Implementation of the SuppliesRepository that interacts with the SupplyRemoteDataProvider
class SupplyRepositoryImpl implements SupplyRepository {
  SupplyRepositoryImpl({
    required this.supplyRemoteDataProvider,
    required this.supplyLocalDataProvider,
  });

  /// The remote data provider for fetching supply data
  final SupplyRemoteDataProvider supplyRemoteDataProvider;

  /// The local data provider for caching supply data
  final SupplyLocalDataProvider supplyLocalDataProvider;

  /// Fetches the full supplies catalog from the remote data provider and caches it locally.
  @override
  Future<List<Supply>> fetchSupplies() async {
    try {
      final suppliesResponse = await supplyRemoteDataProvider.getSupplies();
      final supplies = suppliesResponse
          .map((response) => response.toDomain())
          .toList();

      try {
        await supplyLocalDataProvider.saveSupplies(
          supplies.map((supply) => SupplyEntity.fromDomain(supply)).toList(),
        );
      } catch (_) {
        // A cache write should not block fresh remote data from reaching the UI.
      }

      return supplies;
    } catch (e) {
      final localSupplies = await supplyLocalDataProvider.getSupplies();
      if (localSupplies.isEmpty) {
        throw Exception('Failed to fetch supplies: $e');
      }

      return localSupplies.map((supply) => supply.toDomain()).toList();
    }
  }
}
