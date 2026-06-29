import 'package:flutter/material.dart';
import 'package:restock/resources/presentation/batches/batch_list/widgets/batch_metric_card.dart';

class BatchOverviewMetrics extends StatelessWidget {
  const BatchOverviewMetrics({
    super.key,
    required this.totalActiveBatches,
    required this.nearExpiryCount,
  });

  final int totalActiveBatches;
  final int nearExpiryCount;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: BatchMetricCard(
              label: 'TOTAL ACTIVE BATCHES',
              value: totalActiveBatches.toString(),
              valueColor: const Color(0xFF171A22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: BatchMetricCard(
              label: 'NEAR EXPIRY (30D)',
              value: nearExpiryCount.toString(),
              valueColor: const Color(0xFFD96A2B),
              caption: nearExpiryCount > 0 ? 'Requires attention' : null,
            ),
          ),
        ],
      ),
    );
  }
}
