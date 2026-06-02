import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/domain/entities/register_branch_command.dart';
import 'package:restock/resources/domain/entities/update_branch_command.dart';
import 'package:restock/resources/domain/entities/update_branch_status_command.dart';
import 'package:restock/resources/domain/repositories/branch_repository.dart';
import 'package:restock/resources/infrastructure/data_sources/branch_local_data_provider.dart';
import 'package:restock/resources/infrastructure/data_sources/branch_remote_data_provider.dart';
import 'package:restock/resources/infrastructure/models/branch_entity.dart';
import 'package:restock/resources/infrastructure/models/register_branch_request.dart';
import 'package:restock/resources/infrastructure/models/update_branch_request.dart';
import 'package:restock/resources/infrastructure/models/update_branch_status_request.dart';

/// Implementation of the BranchRepository that interacts with the BranchRemoteDataProvider.
class BranchRepositoryImpl implements BranchRepository {
  /// Constructor for BranchRepositoryImpl.
  BranchRepositoryImpl({
    required this.branchRemoteDataProvider,
    required this.branchLocalDataProvider,
  });

  /// The remote data provider for fetching branch data.
  final BranchRemoteDataProvider branchRemoteDataProvider;

  // The local data provider for caching branch data.
  final BranchLocalDataProvider branchLocalDataProvider;

  /// Fetches a list of branches from the remote data provider.
  @override
  Future<List<Branch>> getBranchesByAccountId(String accountId) async {
    try {
      final branchesResponse = await branchRemoteDataProvider
          .getBranchesByAccountId(accountId);

      final branches = branchesResponse
          .map((resources) => resources.toDomain())
          .toList();

      await branchLocalDataProvider.saveBranches(
        branches
            .map((branches) => BranchEntity.fromDomain(branches, accountId))
            .toList(),
      );

      return branches;
    } catch (_) {
      final localBranches = await branchLocalDataProvider
          .getBranches();
      if (localBranches.isEmpty) {
        throw Exception('No internet connection and no cached data available');
      }
      return localBranches.map((l) => l.toDomain()).toList();
    }
  }

  /// Registers a new branch using the provided command.
  @override
  Future<Branch> registerBranch(RegisterBranchCommand command) async {
    try {
      final request = RegisterBranchRequest(
        name: command.name,
        address: command.address,
        stateOrRegion: command.stateOrRegion,
        city: command.city,
        country: command.country,
        description: command.description,
        image: command.image,
      );
      final branchResponse = await branchRemoteDataProvider.registerBranch(
        request,
        command.accountId,
      );
      return branchResponse.toDomain();
    } catch (e) {
      throw Exception('Failed to register branch: $e');
    }
  }

  /// Updates an existing branch using the provided command.
  @override
  Future<Branch> updateBranch(UpdateBranchCommand command) async {
    try {
      final request = UpdateBranchRequest(
        name: command.name,
        address: command.address,
        city: command.city,
        regionOrState: command.regionOrState,
        country: command.country,
        description: command.description,
        image: command.image,
      );
      final branchResponse = await branchRemoteDataProvider.updateBranch(
        request,
        command.branchId,
      );
      return branchResponse.toDomain();
    } catch (e) {
      throw Exception('Failed to update branch: $e');
    }
  }

  /// Fetches a branch by its ID from the remote data provider.
  @override
  Future<Branch> getBranchById(String branchId) async {
    try {
      final branchResponse = await branchRemoteDataProvider.getBranchById(
        branchId,
      );
      return branchResponse.toDomain();
    } catch (e) {
      throw Exception('Failed to fetch branch: $e');
    }
  }

  /// Updates the status of a branch using the provided command.
  @override
  Future<void> updateBranchStatus(UpdateBranchStatusCommand command) async {
    try {
      final request = UpdateBranchStatusRequest(branchId: command.branchId, status: command.status);
      return await branchRemoteDataProvider.updateBranchStatus(request);
    } catch (e) {
      throw Exception('Failed to update branch status: $e');
    }
  }
}
