import 'package:image_picker/image_picker.dart';
import 'package:restock/resources/domain/repositories/custom_supply_repository.dart';
import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/resources/domain/commands/register_custom_supply_command.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

import '../domain/commands/update_custom_supply_command.dart';

/// Facade service to manage resource-related operations
class CustomSupplyFacadeService {
  /// Constructor for the CustomSupplyFacadeService
  const CustomSupplyFacadeService({
    required this.customSupplyRepository,
    required this.tokenStorage,
  });

  /// Repository for managing custom supply data
  final CustomSupplyRepository customSupplyRepository;

  final TokenStorage tokenStorage;

  /// Fetches a list of custom supplies for the current branch
  Future<List<CustomSupply>> getCustomSuppliesByBranchId() async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) {
        throw Exception('Account ID not found in token storage');
      }

      return await customSupplyRepository.getCustomSuppliesByBranchId(
        accountId,
      );
    } catch (e) {
      throw Exception('Failed to fetch custom supplies: $e');
    }
  }

  Future<CustomSupply> getCustomSupplyById(String customSupplyId) async {
    try {
      return await customSupplyRepository.getCustomSupplyById(customSupplyId);
    } catch (e) {
      throw Exception('Failed to fetch custom supply: $e');
    }
  }

  Future<CustomSupply> registerCustomSupply({
    required String supplyId,
    required String name,
    required String description,
    required String unitPriceAmount,
    required String unitPriceCurrencyCode,
    required double minimumStock,
    required double maximumStock,
    required String unitMeasurement,
    required String unitMeasurementAbbreviation,
    XFile? picture,
  }) async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) {
        throw Exception('Account ID not found in token storage');
      }

      final command = RegisterCustomSupplyCommand(
        accountId: accountId,
        supplyId: supplyId,
        name: name,
        description: description,
        unitPriceAmount: unitPriceAmount,
        unitPriceCurrencyCode: unitPriceCurrencyCode,
        minimumStock: minimumStock,
        maximumStock: maximumStock,
        unitMeasurement: unitMeasurement,
        unitMeasurementAbbreviation: unitMeasurementAbbreviation,
        picture: picture,
      );

      return await customSupplyRepository.registerCustomSupply(command);
    } catch (e) {
      throw Exception('Failed to register custom supply: $e');
    }
  }

  Future<CustomSupply> updateCustomSupply({
    required String customSupplyId,
    required String supplyId,
    required String name,
    required String description,
    required String unitPriceAmount,
    required String unitPriceCurrencyCode,
    required double minimumStock,
    required double maximumStock,
    required String unitMeasurement,
    required String unitMeasurementAbbreviation,
    XFile? picture,
  }) async {
    try {
      final command = UpdateCustomSupplyCommand(
        customSupplyId: customSupplyId,
        supplyId: supplyId,
        name: name,
        description: description,
        unitPriceAmount: unitPriceAmount,
        unitPriceCurrencyCode: unitPriceCurrencyCode,
        minimumStock: minimumStock,
        maximumStock: maximumStock,
        unitMeasurement: unitMeasurement,
        unitMeasurementAbbreviation: unitMeasurementAbbreviation,
        picture: picture,
      );

      return await customSupplyRepository.updateCustomSupply(command);
    } catch (e) {
      throw Exception('Failed to update custom supply: $e');
    }
  }
}
