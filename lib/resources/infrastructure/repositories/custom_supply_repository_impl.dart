import 'package:restock/resources/domain/repositories/custom_supply_repository.dart';
import 'package:restock/resources/infrastructure/data_sources/custom_supply_remote_data_provider.dart';
import 'package:restock/resources/domain/entities/custom_supply.dart';

/// Implementation of the CustomSupplyRepository that interacts with the CustomSupplyRemoteDataProvider
class CustomSupplyRepositoryImpl implements CustomSupplyRepository {

  /// Constructor for CustomSupplyRepositoryImpl
  CustomSupplyRepositoryImpl({
    required this.customSupplyRemoteDataProvider,
  });

  /// The remote data provider for fetching custom supply data
  final CustomSupplyRemoteDataProvider customSupplyRemoteDataProvider;

  /// Fetches a list of custom supplies for the current branch from the remote data provider
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
