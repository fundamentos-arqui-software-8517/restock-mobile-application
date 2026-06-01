import 'dart:convert';
import 'dart:io';

import 'package:restock/iam/infrastructure/interceptor/auth_http_client.dart';
import 'package:restock/resources/infrastructure/models/branch_model.dart';
import 'package:restock/shared/infrastructure/constants/api_constants.dart';

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
  Future<List<BranchResponseModel>> getBranchesByAccountId(String accountId) async {
    try {
      final Uri uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.branchesByAccountId.replaceAll('{accountId}', accountId)}',
      );

      final response = await http.get(uri);

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> data = jsonDecode(response.body);

        return data
            .map((json) => BranchResponseModel.fromJson(json))
            .toList();
      }

      throw Exception(
        'Failed to load branches: ${response.statusCode}',
      );
    } catch (e) {
      rethrow;
    }
  }
}