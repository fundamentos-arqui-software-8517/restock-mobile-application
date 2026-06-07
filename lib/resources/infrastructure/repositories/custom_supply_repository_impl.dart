import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/resources/domain/entities/register_custom_supply_command.dart';
import 'package:restock/resources/domain/entities/update_custom_supply_command.dart';
import 'package:restock/resources/domain/repositories/custom_supply_repository.dart';
import 'package:restock/resources/infrastructure/data_sources/custom_supply_local_data_provider.dart';
import 'package:restock/resources/infrastructure/data_sources/custom_supply_remote_data_provider.dart';
import 'package:restock/resources/infrastructure/data_sources/supply_local_data_provider.dart';
import 'package:restock/resources/infrastructure/data_sources/supply_remote_data_provider.dart';
import 'package:restock/resources/infrastructure/models/custom_supply_entity.dart';
import 'package:restock/resources/infrastructure/models/register_custom_supply_request.dart';
import 'package:restock/resources/infrastructure/models/supply_entity.dart';
import 'package:restock/resources/infrastructure/models/update_custom_supply_request.dart';

/// Implementation of the CustomSupplyRepository that interacts with the CustomSupplyRemoteDataProvider
class CustomSupplyRepositoryImpl implements CustomSupplyRepository {
  /// Constructor for CustomSupplyRepositoryImpl
  CustomSupplyRepositoryImpl({
    required this.customSupplyRemoteDataProvider,
    required this.customSupplyLocalDataProvider,
    required this.supplyRemoteDataProvider,
    required this.supplyLocalDataProvider,
  });

  /// The remote data provider for fetching custom supply data
  final CustomSupplyRemoteDataProvider customSupplyRemoteDataProvider;

  /// The local data provider for caching custom supply data
  final CustomSupplyLocalDataProvider customSupplyLocalDataProvider;

  final SupplyRemoteDataProvider supplyRemoteDataProvider;

  final SupplyLocalDataProvider supplyLocalDataProvider;

  /// Fetches a list of custom supplies for the current branch from the remote data provider
  @override
  Future<List<CustomSupply>> getCustomSuppliesByBranchId() async {
    try {
      final customSuppliesResponse = await customSupplyRemoteDataProvider
          .getCustomSuppliesByBranchId();
      final customSupplies = customSuppliesResponse
          .map((response) => response.toDomain())
          .toList();

      await _tryCacheSupplyCatalog();
      await _tryCacheCustomSupplies(customSupplies);

      return customSupplies;
    } catch (e) {
      final localCustomSupplies = await customSupplyLocalDataProvider
          .getCustomSupplies();
      if (localCustomSupplies.isEmpty) {
        throw Exception('Failed to fetch custom supplies: $e');
      }
      return localCustomSupplies.map((c) => c.toDomain()).toList();
    }
  }

  Future<void> _tryCacheSupplyCatalog() async {
    try {
      final suppliesResponse = await supplyRemoteDataProvider.getSupplies();
      final supplies = suppliesResponse
          .map((response) => SupplyEntity.fromDomain(response.toDomain()))
          .toList();

      await supplyLocalDataProvider.saveSupplies(supplies);
    } catch (_) {
      // A catalog cache write should not block fresh custom supplies.
    }
  }

  Future<void> _tryCacheCustomSupplies(
    List<CustomSupply> customSupplies,
  ) async {
    try {
      await customSupplyLocalDataProvider.saveCustomSupplies(
        customSupplies
            .map((customSupply) => CustomSupplyEntity.fromDomain(customSupply))
            .toList(),
      );
    } catch (_) {
      // A custom supplies cache write should not block fresh remote data.
    }
  }

  @override
  Future<CustomSupply> registerCustomSupply(
    RegisterCustomSupplyCommand command,
  ) async {
    try {
      final request = RegisterCustomSupplyRequest(
        accountId: command.accountId,
        supplyId: command.supplyId,
        name: command.name,
        description: command.description,
        unitPriceAmount: command.unitPriceAmount,
        unitPriceCurrencyCode: command.unitPriceCurrencyCode,
        minimumStock: command.minimumStock,
        maximumStock: command.maximumStock,
        unitMeasurement: command.unitMeasurement,
        unitMeasurementAbbreviation: command.unitMeasurementAbbreviation,
        picture: command.picture,
      );

      final response = await customSupplyRemoteDataProvider
          .registerCustomSupply(request);
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to register custom supply: $e');
    }
  }

  @override
  Future<CustomSupply> updateCustomSupply(
    UpdateCustomSupplyCommand command,
  ) async {
    try {
      final request = UpdateCustomSupplyRequest(
        supplyId: command.supplyId,
        name: command.name,
        description: command.description,
        unitPriceAmount: command.unitPriceAmount,
        unitPriceCurrencyCode: command.unitPriceCurrencyCode,
        minimumStock: command.minimumStock,
        maximumStock: command.maximumStock,
        unitMeasurement: command.unitMeasurement,
        unitMeasurementAbbreviation: command.unitMeasurementAbbreviation,
        picture: command.picture,
      );

      final response = await customSupplyRemoteDataProvider.updateCustomSupply(
        request,
        command.customSupplyId,
      );
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to update custom supply: $e');
    }
  }
}
