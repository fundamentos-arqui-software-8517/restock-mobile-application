import 'package:restock/analytics/domain/entities/analytics_overview.dart';
import 'package:restock/analytics/domain/entities/critical_product.dart';
import 'package:restock/analytics/domain/entities/recent_sale.dart';
import 'package:restock/analytics/domain/entities/stock_discrepancy.dart';
import 'package:restock/analytics/domain/repositories/analytics_repository.dart';
import 'package:restock/analytics/infrastructure/data_sources/analytics_remote_data_provider.dart';
import 'package:restock/resources/domain/repositories/custom_supply_repository.dart';

class MetricRepositoryImpl implements AnalyticsRepository {
  MetricRepositoryImpl({
    required this.metricRemoteDataProvider,
    required this.customSupplyRepository,
  });

  final MetricRemoteDataProvider metricRemoteDataProvider;
  final CustomSupplyRepository customSupplyRepository;

  @override
  Future<List<StockDiscrepancy>> getStockDiscrepancies({
    required String customSupplyId,
    required String productName,
  }) async {
    final models = await metricRemoteDataProvider.getStockDiscrepancies(
      customSupplyId,
    );

    return models
        .map(
          (model) => model.toDomain(
            productId: customSupplyId,
            productName: productName,
          ),
        )
        .toList();
  }

  @override
  Future<List<RecentSale>> getRecentSales({
    required String accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final models = await metricRemoteDataProvider.getRecentSales(
      accountId: accountId,
      startDate: startDate,
      endDate: endDate,
    );

    return models.map((model) => model.toDomain()).toList();
  }

  @override
  Future<List<CriticalProduct>> getCriticalProducts(String accountId) async {
    final models = await metricRemoteDataProvider.getCriticalProducts(
      accountId,
    );

    return models.map((model) => model.toDomain()).toList();
  }

  @override
  Future<AnalyticsOverview> getOverview(String accountId) async {
    final customSupplies = await customSupplyRepository
        .getCustomSuppliesByBranchId(accountId);

    final recentSalesFuture = getRecentSales(accountId: accountId);
    final criticalProductsFuture = getCriticalProducts(accountId);
    final discrepancyGroupsFuture = Future.wait(
      customSupplies.take(12).map((customSupply) async {
        try {
          return await getStockDiscrepancies(
            customSupplyId: customSupply.customSupplyId,
            productName: customSupply.name,
          );
        } catch (_) {
          return <StockDiscrepancy>[];
        }
      }),
    );

    final recentSales = await recentSalesFuture;
    final criticalProducts = await criticalProductsFuture;
    final discrepancyGroups = await discrepancyGroupsFuture;

    final discrepancies =
        discrepancyGroups
            .expand((items) => items)
            .where((item) => !item.isConciliated && item.difference != 0)
            .toList()
          ..sort((a, b) => b.difference.abs().compareTo(a.difference.abs()));

    return AnalyticsOverview(
      discrepancies: discrepancies,
      recentSales: recentSales,
      criticalProducts: criticalProducts,
    );
  }
}
