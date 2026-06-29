import 'package:restock/analytics/domain/entities/analytics_overview.dart';
import 'package:restock/analytics/domain/repositories/analytics_repository.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

class AnalyticsFacadeService {
  AnalyticsFacadeService({
    required this.analyticsRepository,
    required this.tokenStorage,
  });

  final AnalyticsRepository analyticsRepository;
  final TokenStorage tokenStorage;

  Future<AnalyticsOverview> getOverview() async {
    final accountId = await tokenStorage.readAccountId();
    if (accountId == null) {
      throw Exception('Account ID not found in token storage');
    }

    return analyticsRepository.getOverview(accountId);
  }
}
