import 'dart:convert';
import 'dart:io';

import 'package:restock/analytics/infrastructure/models/critical_product_model.dart';
import 'package:restock/analytics/infrastructure/models/recent_sale_model.dart';
import 'package:restock/analytics/infrastructure/models/stock_discrepancy_model.dart';
import 'package:restock/analytics/infrastructure/repositories/constants/analytics_api_constants.dart';
import 'package:restock/iam/infrastructure/interceptor/auth_http_client.dart';
import 'package:restock/shared/infrastructure/repositories/constants/api_constants.dart';

class MetricRemoteDataProvider {
  MetricRemoteDataProvider({required this.http});

  final AuthHttpClient http;

  Future<List<StockDiscrepancyModel>> getStockDiscrepancies(
    String customSupplyId,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${AnalyticsApiConstants.stockDiscrepancies.replaceAll('{id}', customSupplyId)}',
    );

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => StockDiscrepancyModel.fromJson(json)).toList();
    }

    throw Exception(
      'Failed to load stock discrepancies: ${response.statusCode}',
    );
  }

  Future<List<RecentSaleModel>> getRecentSales({
    required String accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final path = AnalyticsApiConstants.recentSales.replaceAll(
      '{accountId}',
      accountId,
    );
    final queryParameters = <String, String>{
      if (startDate != null) 'startDate': _formatDate(startDate),
      if (endDate != null) 'endDate': _formatDate(endDate),
    };
    final uri = Uri.parse('${ApiConstants.baseUrl}$path').replace(
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => RecentSaleModel.fromJson(json)).toList();
    }

    throw Exception('Failed to load recent sales: ${response.statusCode}');
  }

  Future<List<CriticalProductModel>> getCriticalProducts(
    String accountId,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${AnalyticsApiConstants.criticalProducts.replaceAll('{accountId}', accountId)}',
    );

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => CriticalProductModel.fromJson(json)).toList();
    }

    throw Exception('Failed to load critical products: ${response.statusCode}');
  }

  String _formatDate(DateTime value) {
    return '${value.year.toString().padLeft(4, '0')}-'
        '${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')}';
  }
}
