import 'package:restock/analytics/domain/entities/analytics_overview.dart';
import 'package:restock/analytics/domain/entities/critical_product.dart';
import 'package:restock/analytics/domain/entities/recent_sale.dart';
import 'package:restock/analytics/domain/entities/stock_discrepancy.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class DashboardState {
  const DashboardState({
    this.status = Status.initial,
    this.discrepancies = const [],
    this.recentSales = const [],
    this.criticalProducts = const [],
    this.errorMessage,
  });

  final Status status;
  final List<StockDiscrepancy> discrepancies;
  final List<RecentSale> recentSales;
  final List<CriticalProduct> criticalProducts;
  final String? errorMessage;

  bool get hasData =>
      discrepancies.isNotEmpty ||
      recentSales.isNotEmpty ||
      criticalProducts.isNotEmpty;

  factory DashboardState.fromOverview(
    AnalyticsOverview overview, {
    Status status = Status.success,
  }) {
    return DashboardState(
      status: status,
      discrepancies: overview.discrepancies,
      recentSales: overview.recentSales,
      criticalProducts: overview.criticalProducts,
    );
  }

  DashboardState copyWith({
    Status? status,
    List<StockDiscrepancy>? discrepancies,
    List<RecentSale>? recentSales,
    List<CriticalProduct>? criticalProducts,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DashboardState(
      status: status ?? this.status,
      discrepancies: discrepancies ?? this.discrepancies,
      recentSales: recentSales ?? this.recentSales,
      criticalProducts: criticalProducts ?? this.criticalProducts,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
