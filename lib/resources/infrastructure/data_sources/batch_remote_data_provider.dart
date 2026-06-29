import 'dart:convert';
import 'dart:io';

import 'package:restock/iam/infrastructure/interceptor/auth_http_client.dart';
import 'package:restock/resources/infrastructure/models/register_batch_request.dart';
import 'package:restock/resources/infrastructure/models/transfer_batch_request.dart';
import 'package:restock/resources/infrastructure/models/update_batch_request.dart';
import 'package:restock/resources/infrastructure/repositories/constants/resources_api_constants.dart';
import 'package:restock/shared/infrastructure/repositories/constants/api_constants.dart';

import '../models/batch_response_model.dart';

/// Data provider for batch-related API calls.
/// This class handles the HTTP requests to the backend for batch operations such as fetching, registering, and updating batches.
class BatchRemoteDataProvider {
  BatchRemoteDataProvider({required this.http});

  final AuthHttpClient http;

  /// Fetches batches for a specific branch. Optionally, you can filter by a custom supply ID.
  Future<List<BatchResponseModel>> getBatchesByBranchId({
    required String accountId,
    required String branchId,
    String? customSupplyId,
  }) async {
    final queryParameters = <String, String>{
      'branchId': branchId,
      if (customSupplyId != null && customSupplyId.isNotEmpty)
        'customSupplyId': customSupplyId,
    };

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ResourcesApiConstants.batches}',
    ).replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final data = jsonDecode(response.body) as List;

      return data
          .map((j) => BatchResponseModel.fromJson(Map<String, dynamic>.from(j)))
          .toList();
    }
    throw Exception(
      'Failed to load batches: ${response.statusCode} ${response.body}',
    );
  }

  /// Registers a new batch with the provided details. The account ID is required to associate the batch with the correct account.
  Future<BatchResponseModel> registerBatch(
    RegisterBatchRequest request,
    String accountId,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ResourcesApiConstants.batches}',
    ).replace(queryParameters: {'accountId': accountId});

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == HttpStatus.created ||
        response.statusCode == HttpStatus.ok) {
      return BatchResponseModel.fromJson(jsonDecode(response.body));
    }
    throw Exception(
      'Failed to register batch: ${response.statusCode} ${response.body}',
    );
  }

  /// Updates an existing batch with the provided details. The batch ID is required to identify which batch to update.
  Future<BatchResponseModel> updateBatch(
    UpdateBatchRequest request,
    String batchId,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ResourcesApiConstants.batchById.replaceAll('{batchId}', batchId)}',
    );
    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == HttpStatus.ok) {
      return BatchResponseModel.fromJson(jsonDecode(response.body));
    }
    throw Exception(
      'Failed to update batch: ${response.statusCode} ${response.body}',
    );
  }

  /// Transfers a batch to another branch. The batch ID is required to identify which batch to transfer, and the request contains the details of the transfer.
  Future<BatchResponseModel> transferBatch(
      TransferBatchRequest request, 
      String batchId
      ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ResourcesApiConstants.transferBatchById.replaceAll('{batchId}', batchId)}',
    );

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == HttpStatus.ok) {
      return BatchResponseModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      'Failed to transfer batch: ${response.statusCode} ${response.body}',
    );
  }
}
