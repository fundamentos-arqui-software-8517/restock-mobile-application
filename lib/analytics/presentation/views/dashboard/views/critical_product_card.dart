import 'package:flutter/material.dart';
import 'package:restock/analytics/domain/entities/critical_product.dart';
import 'package:restock/analytics/presentation/views/dashboard/views/dashboard_card.dart';

import '../../../../../shared/presentation/utils/ui/theme.dart';

class CriticalProductCard extends StatelessWidget {
  const CriticalProductCard({super.key, required this.product});

  final CriticalProduct product;

  @override
  Widget build(BuildContext context) {
    final deficit = product.stockDeficit == 0
        ? product.minStock - product.totalStock
        : product.stockDeficit;
    final unit = product.unitMeasurement;

    return DashboardCard(
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            color: green,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.branchName} · ${product.totalStock}/${product.minStock}$unit',
                  style: const TextStyle(
                    color: muted,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '-${deficit.abs().toStringAsFixed(1)}$unit',
            style: const TextStyle(
              color: red,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}