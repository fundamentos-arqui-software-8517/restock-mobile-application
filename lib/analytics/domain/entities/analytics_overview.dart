import 'package:restock/analytics/domain/entities/critical_product.dart';
import 'package:restock/analytics/domain/entities/recent_sale.dart';
import 'package:restock/analytics/domain/entities/stock_discrepancy.dart';

class AnalyticsOverview {
  const AnalyticsOverview({
    required this.discrepancies,
    required this.recentSales,
    required this.criticalProducts,
  });

  final List<StockDiscrepancy> discrepancies;
  final List<RecentSale> recentSales;
  final List<CriticalProduct> criticalProducts;
}
