import 'package:flutter/material.dart';
import 'package:restock/analytics/domain/entities/stock_discrepancy.dart';
import 'package:restock/analytics/presentation/views/dashboard/views/dashboard_card.dart';

import '../../../../../shared/presentation/utils/ui/theme.dart';

class DiscrepancyCard extends StatelessWidget {
  const DiscrepancyCard({super.key, required this.item});

  final StockDiscrepancy item;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: dangerBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: red,
              size: 34,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_fallbackLabel(item.riskLevel, 'RISK')} · ${_fallbackLabel(item.status, 'PENDING')}',
                  style: const TextStyle(
                    color: muted,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${item.difference.toStringAsFixed(1)}kg',
            style: const TextStyle(
              color: red,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            color: muted,
            size: 34,
          ),
        ],
      ),
    );
  }

  static String _fallbackLabel(String value, String fallback) {
    final normalized = value.trim();
    return normalized.isEmpty ? fallback : normalized.toUpperCase();
  }
}