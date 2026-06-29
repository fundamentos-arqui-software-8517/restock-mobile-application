import 'package:restock/analytics/domain/entities/analytics_overview.dart';
import 'package:restock/analytics/domain/entities/critical_product.dart';
import 'package:restock/analytics/domain/entities/recent_sale.dart';
import 'package:restock/analytics/domain/entities/stock_discrepancy.dart';

abstract class AnalyticsRepository {
  Future<List<StockDiscrepancy>> getStockDiscrepancies({
    required String customSupplyId,
    required String productName,
  });

  Future<List<RecentSale>> getRecentSales({
    required String accountId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<List<CriticalProduct>> getCriticalProducts(String accountId);

  Future<AnalyticsOverview> getOverview(String accountId);
}
