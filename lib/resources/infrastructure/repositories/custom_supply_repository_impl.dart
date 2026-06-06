import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/resources/domain/entities/register_custom_supply_command.dart';
import 'package:restock/resources/domain/entities/update_custom_supply_command.dart';
import 'package:restock/resources/domain/repositories/custom_supply_repository.dart';
import 'package:restock/resources/infrastructure/data_sources/custom_supply_remote_data_provider.dart';
import 'package:restock/resources/infrastructure/models/register_custom_supply_request.dart';
import 'package:restock/resources/infrastructure/models/update_custom_supply_request.dart';

/// Implementation of the CustomSupplyRepository that interacts with the CustomSupplyRemoteDataProvider
class CustomSupplyRepositoryImpl implements CustomSupplyRepository {
  /// Constructor for CustomSupplyRepositoryImpl
  CustomSupplyRepositoryImpl({required this.customSupplyRemoteDataProvider});

  /// The remote data provider for fetching custom supply data
  final CustomSupplyRemoteDataProvider customSupplyRemoteDataProvider;

  /// Fetches a list of custom supplies for the current branch from the remote data provider
  @override
  Future<List<CustomSupply>> getCustomSuppliesByBranchId() async {
    try {
      final customSuppliesResponse = await customSupplyRemoteDataProvider
          .getCustomSuppliesByBranchId();
      return customSuppliesResponse
          .map((response) => response.toDomain())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch custom supplies: $e');
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
