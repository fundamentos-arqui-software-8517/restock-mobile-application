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
      child: device.hasBatch
          ? _BatchInfo(device: device, onAssign: onAssignBatch)
          : _EmptyBatch(onAssign: onAssignBatch),
    );
  }
}

class _BatchInfo extends StatelessWidget {
  const _BatchInfo({required this.device, required this.onAssign});

  final Device device;
  final VoidCallback onAssign;

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
            OutlinedButton.icon(
              onPressed: onAssign,
              icon: const Icon(Icons.swap_horiz_rounded, size: 16),
              label: const Text('Change'),
              style: OutlinedButton.styleFrom(
                foregroundColor: DevicesTheme.textPrimary,
                side: const BorderSide(color: DevicesTheme.borderGray),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _InfoRow(label: 'Batch ID', value: device.assignedBatchId ?? '—'),
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
