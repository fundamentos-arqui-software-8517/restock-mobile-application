import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as pkg_http;
import 'package:restock/iam/infrastructure/interceptor/auth_http_client.dart';
import 'package:restock/resources/domain/commands/update_branch_status_command.dart';
import 'package:restock/resources/infrastructure/models/branch_response_model.dart';
import 'package:restock/resources/infrastructure/models/register_branch_request.dart';
import 'package:restock/resources/infrastructure/models/update_branch_request.dart';
import 'package:restock/resources/infrastructure/models/update_branch_status_request.dart';
import 'package:restock/resources/infrastructure/repositories/constants/resources_api_constants.dart';
import 'package:restock/shared/infrastructure/repositories/constants/api_constants.dart';

/// A data provider for fetching branch data from a remote API.
class BranchRemoteDataProvider {
  /// The HTTP client used to make requests to the API.
  final AuthHttpClient http;

  /// Constructor for BranchRemoteDataProvider.
  BranchRemoteDataProvider({required this.http});

  /// Fetches all branches from the remote API.
  ///
  /// Returns a list of [BranchResponseModel] objects if the request is successful.
  ///
  /// Throws an exception if the request fails.
  Future<List<BranchResponseModel>> getBranchesByAccountId(
    String accountId,
  ) async {
    try {
      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}${ResourcesApiConstants.branches}'
      ).replace(queryParameters: {'accountId': accountId}
      );

      final response = await http.get(uri);

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((json) => BranchResponseModel.fromJson(json)).toList();
      }

      throw Exception('Failed to load branches: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  /// Registers a new branch with the given [RegisterBranchRequest] and [accountId].
  Future<BranchResponseModel> registerBranch(
    RegisterBranchRequest request,
    String accountId,
  ) async {
    try {
      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}${ResourcesApiConstants.branches}'
      ).replace(queryParameters: {'accountId': accountId});

      final multipartRequest = await request.toMultipartRequest(uri, 'POST');

      final streamedResponse = await http.send(multipartRequest);
      final response = await pkg_http.Response.fromStream(streamedResponse);

      if (response.statusCode == HttpStatus.created) {
        return BranchResponseModel.fromJson(jsonDecode(response.body));
      }

      throw Exception('Failed to register branch: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error registering branch: $e');
    }
  }

  /// Updates an existing branch with the given [UpdateBranchRequest] and [branchId].
  Future<BranchResponseModel> updateBranch(
    UpdateBranchRequest request,
    String branchId,
  ) async {
    try {
      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}${ResourcesApiConstants.branchById.replaceAll('{branchId}', branchId)}',
      );

      final multipartRequest = await request.toMultipartRequest(uri);
      final streamedResponse = await http.send(multipartRequest);
      final response = await pkg_http.Response.fromStream(streamedResponse);

      if (response.statusCode == HttpStatus.ok) {
        return BranchResponseModel.fromJson(jsonDecode(response.body));
      }

      throw Exception('Failed to update branch: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches a branch by its ID from the remote API.
  Future<BranchResponseModel> getBranchById(String branchId) async {
    try {
      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}${ResourcesApiConstants.branchById.replaceAll('{branchId}', branchId)}',
      );
      final response = await http.get(uri);

      if (response.statusCode == HttpStatus.ok) {
        return BranchResponseModel.fromJson(jsonDecode(response.body));
      }
      throw Exception('Failed to load branch: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  /// Updates the status of a branch with the given [UpdateBranchStatusCommand] and [branchId].
  Future<void> updateBranchStatus(UpdateBranchStatusRequest command) async {
    try {
      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}${ResourcesApiConstants.branchStatus.replaceAll('{branchId}', command.branchId)}',
      );
      final response = await http.patch(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': command.status}),
      );
      if (response.statusCode == 204 || response.statusCode == 200) {
        return;
      }
    } catch (e) {
      rethrow;
    }
  }
}
