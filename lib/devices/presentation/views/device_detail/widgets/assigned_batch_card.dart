import 'package:flutter/material.dart';
import 'package:restock/devices/domain/entities/device.dart';
import 'package:restock/devices/presentation/utils/devices_theme.dart';

class AssignedBatchCard extends StatelessWidget {
  const AssignedBatchCard({
    super.key,
    required this.device,
    required this.onAssignBatch,
  });

  final Device device;
  final VoidCallback onAssignBatch;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: DevicesTheme.sidePadding,
        vertical: 6,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DevicesTheme.cardBackground,
        borderRadius: BorderRadius.circular(DevicesTheme.radiusMd),
        border: Border.all(color: DevicesTheme.borderGray),
      ),
      child: device.hasBatch ? _BatchInfo(device: device) : _EmptyBatch(onAssign: onAssignBatch),
    );
  }
}

class _BatchInfo extends StatelessWidget {
  const _BatchInfo({required this.device});

  final Device device;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 18,
              color: DevicesTheme.greenPrimary,
            ),
            const SizedBox(width: 8),
            const Text(
              'Assigned Batch',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: DevicesTheme.textPrimary,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: DevicesTheme.healthyBg,
                borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
                border: Border.all(color: DevicesTheme.healthyBorder),
              ),
              child: const Text(
                'ASSIGNED',
                style: TextStyle(
                  color: DevicesTheme.healthyText,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _InfoRow(label: 'Supply ID', value: device.customSupplyId ?? '—'),
        if (device.measurement != null) ...[
          const SizedBox(height: 6),
          _InfoRow(
            label: 'Weight unit',
            value: device.measurement!.weightUnit,
          ),
          _InfoRow(
            label: 'Unit weight',
            value: '${device.measurement!.unitWeight}',
          ),
          _InfoRow(
            label: 'Tare weight',
            value: '${device.measurement!.tareWeight}',
          ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 13,
              color: DevicesTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: DevicesTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBatch extends StatelessWidget {
  const _EmptyBatch({required this.onAssign});

  final VoidCallback onAssign;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 18,
              color: DevicesTheme.textSecondary,
            ),
            SizedBox(width: 8),
            Text(
              'No Batch Assigned',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: DevicesTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Assign a supply batch to configure this device and start monitoring inventory.',
          style: TextStyle(
            fontSize: 13,
            color: DevicesTheme.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: onAssign,
            style: ElevatedButton.styleFrom(
              backgroundColor: DevicesTheme.greenPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
              ),
            ),
            child: const Text(
              'Assign Batch',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
