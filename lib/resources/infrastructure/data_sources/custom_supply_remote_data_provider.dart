import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as pkg_http;
import 'package:restock/iam/infrastructure/interceptor/auth_http_client.dart';
import 'package:restock/resources/infrastructure/models/custom_supply_model.dart';
import 'package:restock/resources/infrastructure/models/register_custom_supply_request.dart';
import 'package:restock/resources/infrastructure/models/update_custom_supply_request.dart';
import 'package:restock/resources/infrastructure/repositories/constants/resources_api_constants.dart';
import 'package:restock/shared/infrastructure/repositories/constants/api_constants.dart';

/// A data provider for fetching custom supply data from a remote API.
///
/// This class uses the `http` package to make GET requests to the API endpoint defined in `ApiConstants`.
///
/// The `getCustomSuppliesByBranchId` method retrieves a list of custom supplies based on the branch ID and returns a list of `CustomSupplyResponseModel` objects.
class CustomSupplyRemoteDataProvider {
  CustomSupplyRemoteDataProvider({required this.http});

  final AuthHttpClient http;

  /// Fetches custom supplies for a specific branch ID from the remote API.
  ///
  /// Returns a list of `CustomSupplyResponseModel` objects if the request is successful.
  ///
  /// Throws an exception if the request fails or if the response status code is not OK.
  Future<List<CustomSupplyResponseModel>> getCustomSuppliesByBranchId(
    String accountId,
  ) async {
    try {
      final Uri uri = Uri.parse(
        "${ApiConstants.baseUrl}${ResourcesApiConstants.customSupplies}",
      ).replace(queryParameters: {'accountId': accountId});

      final response = await http.get(uri);

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => CustomSupplyResponseModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to load custom supplies: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CustomSupplyResponseModel> getCustomSupplyById(
    String customSupplyId,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ResourcesApiConstants.customSupplyById.replaceAll('{customSupplyId}', customSupplyId)}',
      );

      final response = await http.get(uri);

      if (response.statusCode == HttpStatus.ok) {
        return CustomSupplyResponseModel.fromJson(jsonDecode(response.body));
      }

      throw Exception('Failed to load custom supply: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<CustomSupplyResponseModel> registerCustomSupply(
    RegisterCustomSupplyRequest request,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ResourcesApiConstants.customSupplies}',
      );
      final multipartRequest = await request.toMultipartRequest(uri);

      final streamedResponse = await http.send(multipartRequest);
      final response = await pkg_http.Response.fromStream(streamedResponse);

      if (response.statusCode == HttpStatus.created ||
          response.statusCode == HttpStatus.ok) {
        return CustomSupplyResponseModel.fromJson(jsonDecode(response.body));
      }

      if (response.statusCode == HttpStatus.internalServerError) {
        final createdSupply = await _findCreatedSupply(request);
        if (createdSupply != null) return createdSupply;
      }

      throw Exception(
        'Failed to register custom supply: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception('Error registering custom supply: $e');
    }
  }

  Future<CustomSupplyResponseModel> updateCustomSupply(
    UpdateCustomSupplyRequest request,
    String customSupplyId,
  ) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ResourcesApiConstants.customSupplyById.replaceAll('{customSupplyId}', customSupplyId)}',
      );
      final multipartRequest = await request.toMultipartRequest(uri);

      final streamedResponse = await http.send(multipartRequest);
      final response = await pkg_http.Response.fromStream(streamedResponse);

      if (response.statusCode == HttpStatus.ok) {
        return CustomSupplyResponseModel.fromJson(jsonDecode(response.body));
      }

      throw Exception('Failed to update custom supply: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error updating custom supply: $e');
    }
  }

  Future<CustomSupplyResponseModel?> _findCreatedSupply(
    RegisterCustomSupplyRequest request,
  ) async {
    try {
      final supplies = await getCustomSuppliesByBranchId(request.accountId);
      for (final supply in supplies) {
        final hasSameName =
            supply.name.trim().toLowerCase() ==
            request.name.trim().toLowerCase();
        final hasSameAccount =
            supply.accountId.isEmpty || supply.accountId == request.accountId;
        final hasSameSupply =
            supply.supply.supplyId.isEmpty ||
            supply.supply.supplyId == request.supplyId;

        if (hasSameName && hasSameAccount && hasSameSupply) {
          return supply;
        }
      }
    } catch (_) {
      return null;
    }

    return null;
  }
}
