import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/domain/entities/register_branch_command.dart';
import 'package:restock/resources/domain/entities/update_branch_command.dart';
import 'package:restock/resources/domain/repositories/branch_repository.dart';
import 'package:restock/resources/infrastructure/data_sources/branch_remote_data_provider.dart';
import 'package:restock/resources/infrastructure/models/register_branch_request.dart';
import 'package:restock/resources/infrastructure/models/update_branch_request.dart';

/// Implementation of the BranchRepository that interacts with the BranchRemoteDataProvider.
class BranchRepositoryImpl implements BranchRepository {
  /// Constructor for BranchRepositoryImpl.
  BranchRepositoryImpl({required this.branchRemoteDataProvider});

  /// The remote data provider for fetching branch data.
  final BranchRemoteDataProvider branchRemoteDataProvider;

  /// Fetches a list of branches from the remote data provider.
  @override
  Future<List<Branch>> getBranchesByAccountId(String accountId) async {
    try {
      final branchesResponse = await branchRemoteDataProvider
          .getBranchesByAccountId(accountId);

      return branchesResponse.map((response) => response.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to fetch branches: $e');
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
        command.accountId, // ← accountId para el endpoint correcto
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
}
