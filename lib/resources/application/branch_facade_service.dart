import 'package:image_picker/image_picker.dart';
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/domain/entities/register_branch_command.dart';
import 'package:restock/resources/domain/entities/update_branch_command.dart';
import 'package:restock/resources/domain/repositories/branch_repository.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

/// Facade service to manage branch-related operations.
class BranchFacadeService {
  /// Constructor for the BranchFacadeService.
  const BranchFacadeService({
    required this.branchRepository,
    required this.tokenStorage,
  });

  /// Repository for managing branch data.
  final BranchRepository branchRepository;

  /// Storage for managing authentication tokens and related data.
  final TokenStorage tokenStorage;

  /// Fetches a list of branches associated with the current account ID.
  Future<List<Branch>> getBranchesByAccountId() async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) {
        throw Exception('Account ID not found in token storage');
      }
      return await branchRepository.getBranchesByAccountId(accountId);
    } catch (e) {
      throw Exception('Failed to fetch branches: $e');
    }
  }

  /// Registers a new branch with the provided details.
  Future<Branch> registerBranch({
    required String name,
    required String address,
    required String stateOrRegion,
    required String city,
    required String country,
    required String description,
    XFile? image,
  }) async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) {
        throw Exception('Account ID not found in token storage');
      }

      final command = RegisterBranchCommand(
        accountId: accountId,
        name: name,
        address: address,
        stateOrRegion: stateOrRegion,
        city: city,
        country: country,
        description: description,
        image: image,
      );
      return await branchRepository.registerBranch(command);
    } catch (e) {
      throw Exception('Failed to register branch: $e');
    }
  }

  /// Updates an existing branch with the provided details.
  Future<Branch> updateBranch({
    required String branchId,
    required String name,
    required String address,
    required String stateOrRegion,
    required String city,
    required String country,
    required String description,
    XFile? image,
  }) async {
    try {
      final command = UpdateBranchCommand(
        branchId: branchId,
        name: name,
        address: address,
        regionOrState: stateOrRegion,
        city: city,
        country: country,
        description: description,
        image: image,
      );
      return await branchRepository.updateBranch(command);
    } catch (e) {
      throw Exception('Failed to update branch: $e');
    }
  }

  // Fetches a branch by its ID.
  Future<Branch> getBranchById(String branchId) async {
  try {
    return await branchRepository.getBranchById(branchId);
  } catch (e) {
    throw Exception('Failed to fetch branch: $e');
  }
}
}
