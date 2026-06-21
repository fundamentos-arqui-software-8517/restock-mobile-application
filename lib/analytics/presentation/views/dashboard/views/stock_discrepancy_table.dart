import 'package:flutter/material.dart';
import 'package:restock/analytics/domain/entities/stock_discrepancy.dart';
import 'package:restock/analytics/presentation/views/dashboard/utils/dashboard_formatters.dart';
import 'package:restock/analytics/presentation/views/dashboard/views/dashboard_card.dart';

import '../../../../../shared/presentation/utils/ui/theme.dart';

class StockDiscrepancyTable extends StatelessWidget {
  const StockDiscrepancyTable({super.key, required this.discrepancies});

  final List<StockDiscrepancy> discrepancies;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 700) {
          return Column(
            children: [
              for (var index = 0; index < discrepancies.length; index++) ...[
                _StockDiscrepancyListItem(item: discrepancies[index]),
                if (index != discrepancies.length - 1)
                  const SizedBox(height: 12),
              ],
            ],
          );
        }

        return DashboardCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              const _HeaderRow(),
              const Divider(height: 1, color: line),
              for (final item in discrepancies) _DataRow(item: item),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _Cell('DISCREPANCY ID', flex: 2, isHeader: true),
          _Cell('PHYSICAL STOCK', flex: 2, isHeader: true),
          _Cell('SYSTEM STOCK', flex: 2, isHeader: true),
          _Cell('DIFFERENCE', flex: 2, isHeader: true),
          _Cell('RISK LEVEL', flex: 2, isHeader: true),
          _Cell('RECONCILED', flex: 2, isHeader: true),
          _Cell('STATUS', flex: 2, isHeader: true),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.item});

  final StockDiscrepancy item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          _Cell(_fallback(item.discrepancyId, '-'), flex: 2),
          _Cell(formatStock(item.physicalStock), flex: 2),
          _Cell(formatStock(item.systemStock), flex: 2),
          _Cell(formatStock(item.difference), flex: 2, emphasize: true),
          _Cell(_fallback(item.riskLevel, '-'), flex: 2),
          _Cell(item.isConciliated ? 'Yes' : 'No', flex: 2),
          _Cell(_fallback(item.status, '-'), flex: 2),
        ],
      ),
    );
  }
}

class _StockDiscrepancyListItem extends StatelessWidget {
  const _StockDiscrepancyListItem({required this.item});

  final StockDiscrepancy item;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _fallback(item.productName, _fallback(item.discrepancyId, '-')),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ink,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          _MobileValueRow(
            label: 'Physical stock',
            value: formatStock(item.physicalStock),
          ),
          _MobileValueRow(
            label: 'System stock',
            value: formatStock(item.systemStock),
          ),
          _MobileValueRow(
            label: 'Difference',
            value: formatStock(item.difference),
            emphasize: true,
          ),
          _MobileValueRow(
            label: 'Risk level',
            value: _fallback(item.riskLevel, '-'),
          ),
          _MobileValueRow(label: 'Status', value: _fallback(item.status, '-')),
        ],
      ),
    );
  }
}

class _MobileValueRow extends StatelessWidget {
  const _MobileValueRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: muted,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: emphasize ? green : ink,
              fontSize: 14,
              fontWeight: emphasize ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(
    this.value, {
    required this.flex,
    this.isHeader = false,
    this.emphasize = false,
  });

  final String value;
  final int flex;
  final bool isHeader;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isHeader ? muted : ink,
          fontSize: isHeader ? 12 : 14,
          fontWeight: isHeader || emphasize ? FontWeight.w900 : FontWeight.w700,
          letterSpacing: isHeader ? 0.8 : 0,
        ),
      ),
    );
  }
}

String _fallback(String value, String fallback) {
  final normalized = value.trim();
  return normalized.isEmpty ? fallback : normalized;
}
