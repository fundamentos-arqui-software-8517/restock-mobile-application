import 'package:flutter/material.dart';
import 'package:restock/resources/domain/entities/batch.dart';
import 'package:restock/resources/presentation/batches/batch_detail/widgets/batch_detail_info_section.dart';
import 'package:restock/resources/presentation/batches/batch_detail/widgets/batch_detail_metric_card.dart';
import 'package:restock/shared/presentation/widgets/network_aware_image.dart';

class BatchDetailContent extends StatelessWidget {
  const BatchDetailContent({super.key, required this.batch});

  final Batch batch;

  static const _ink = Color(0xFF0D1B2A);
  static const _muted = Color(0xFF5A6472);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      children: [
        Text(
          _batchTitle,
          style: const TextStyle(
            color: _ink,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (_shouldShowCodeSubtitle) ...[
          const SizedBox(height: 6),
          Text(
            batch.code,
            style: const TextStyle(
              color: _muted,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 26),
        Row(
          children: [
            Expanded(
              child: BatchDetailMetricCard(
                label: 'Stock',
                value: _formatStockNumber(batch),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: BatchDetailMetricCard(
                label: 'Expiry',
                value: _formatDate(batch.expirationDate),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: BatchDetailMetricCard(
                label: 'UOM',
                value: batch.unitMeasurement.isEmpty
                    ? batch.unitMeasurementAbbreviation
                    : batch.unitMeasurement,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        BatchDetailInfoSection(
          title: 'Batch Information',
          children: [
            BatchDetailInfoRow(label: 'Code', value: batch.code),
            BatchDetailInfoRow(
              label: 'Current stock',
              value: _formatStockNumber(batch),
            ),
          ],
        ),
        const SizedBox(height: 14),
        BatchDetailInfoSection(
          title: 'Dates',
          children: [
            BatchDetailInfoRow(
              label: 'Entry date',
              value: _formatDate(batch.entryDate),
            ),
            BatchDetailInfoRow(
              label: 'Expiration',
              value: _formatDate(batch.expirationDate),
            ),
          ],
        ),
        const SizedBox(height: 14),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: const Color(0xFFEFF3F6),
              child: NetworkAwareImage(
                imageUrl: batch.pictureUrl,
                fit: BoxFit.cover,
                placeholder: const Icon(
                  Icons.inventory_2_outlined,
                  color: Color(0xFF9AA5B4),
                  size: 54,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String get _batchTitle {
    if (batch.customSupplyName?.isNotEmpty == true) {
      return batch.customSupplyName!;
    }

    return batch.code;
  }

  bool get _shouldShowCodeSubtitle {
    return batch.customSupplyName?.isNotEmpty == true &&
        batch.customSupplyName != batch.code;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatStockNumber(Batch batch) =>
      batch.currentStock.toStringAsFixed(2);
}
