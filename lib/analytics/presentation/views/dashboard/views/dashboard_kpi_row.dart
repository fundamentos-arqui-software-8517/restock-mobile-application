import 'package:flutter/material.dart';
import 'package:restock/analytics/presentation/views/dashboard/bloc/dashboard_state.dart';
import 'package:restock/analytics/presentation/views/dashboard/utils/dashboard_formatters.dart';
import 'package:restock/analytics/presentation/views/dashboard/views/dashboard_kpi_card.dart';

class DashboardKpiRow extends StatelessWidget {
  const DashboardKpiRow({
    super.key,
    required this.state,
    required this.activeScales,
  });

  final DashboardState state;
  final int activeScales;

  @override
  Widget build(BuildContext context) {
    final highRiskCount = state.discrepancies
        .where((item) => item.riskLevel.toLowerCase().contains('high'))
        .length;
    final totalDeficit = state.criticalProducts.fold<double>(0, (
      total,
      product,
    ) {
      final deficit = product.stockDeficit == 0
          ? product.minStock - product.totalStock
          : product.stockDeficit;
      return total + deficit.abs();
    });
    final totalSales = state.recentSales.fold<double>(
      0,
      (total, sale) => total + sale.totalAmount,
    );

    final cards = [
      DashboardKpiCard(title: 'ACTIVE SCALES', value: activeScales.toString()),
      DashboardKpiCard(
        title: 'STOCK DISCREPANCIES',
        value: state.discrepancies.length.toString(),
        caption: '$highRiskCount high risk',
      ),
      DashboardKpiCard(
        title: 'CRITICAL PRODUCTS',
        value: state.criticalProducts.length.toString(),
        caption: 'Deficit: ${formatDecimal(totalDeficit)}',
      ),
      DashboardKpiCard(
        title: 'RECENT SALES',
        value: state.recentSales.length.toString(),
        caption: 'Total: ${formatMoney(totalSales)}',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 680) {
          final itemWidth = (constraints.maxWidth - 14) / 2;
          return Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              for (final card in cards) SizedBox(width: itemWidth, child: card),
            ],
          );
        }

        return Row(
          children: [
            for (var index = 0; index < cards.length; index++) ...[
              Expanded(child: cards[index]),
              if (index != cards.length - 1) const SizedBox(width: 14),
            ],
          ],
        );
      },
    );
  }
}
