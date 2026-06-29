import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/domain/commands/register_branch_command.dart';
import 'package:restock/resources/domain/repositories/branch_repository.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

import '../domain/commands/update_branch_command.dart';
import '../domain/commands/update_branch_status_command.dart';

/// Facade service to manage branch-related operations.
class BranchFacadeService {
  /// Constructor for the BranchFacadeService.
  BranchFacadeService({
    required this.branchRepository,
    required this.tokenStorage,
  });

  /// Repository for managing branch data.
  final BranchRepository branchRepository;

  /// Storage for managing authentication tokens and related data.
  final TokenStorage tokenStorage;

  final ValueNotifier<String?> _activeBranchId = ValueNotifier<String?>(null);

  ValueListenable<String?> get activeBranchIdListenable => _activeBranchId;

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

  /// Reads the locally selected branch.
  Future<String?> getActiveBranchId() async {
    return await tokenStorage.readBranchId();
  }

  /// Saves the locally selected branch.
  Future<void> setActiveBranchId(String branchId) async {
    await tokenStorage.saveBranchId(branchId);
    _activeBranchId.value = branchId;
  }

  /// Ensures there is a selected branch available for branch-scoped features.
  Future<String?> resolveActiveBranchId(List<Branch> branches) async {
    if (branches.isEmpty) return null;

    final selectedBranchId = await tokenStorage.readBranchId();
    final selectableBranches = _selectableBranches(branches);
    final selectedBranchExists = selectableBranches.any(
      (branch) => branch.branchId == selectedBranchId,
    );

    final resolvedBranchId = selectedBranchExists
        ? selectedBranchId!
        : selectableBranches.first.branchId;

    if (resolvedBranchId != selectedBranchId) {
      await tokenStorage.saveBranchId(resolvedBranchId);
      _activeBranchId.value = resolvedBranchId;
    }

    return resolvedBranchId;
  }

  List<Branch> _selectableBranches(List<Branch> branches) {
    final activeBranches = branches
        .where((branch) => branch.status.toLowerCase() == 'active')
        .toList();

    return activeBranches.isEmpty ? branches : activeBranches;
  }

  /// Updates the status of a branch with the provided status.
  Future<void> updateBranchStatus(String branchId, String status) async {
    try {
      final updateBranchStatusCommand = UpdateBranchStatusCommand(
        status: status,
        branchId: branchId,
      );
      await branchRepository.updateBranchStatus(updateBranchStatusCommand);
    } catch (e) {
      throw Exception('Failed to update branch status: $e');
    }
  }
}
