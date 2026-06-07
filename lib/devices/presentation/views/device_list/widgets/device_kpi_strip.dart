import 'package:flutter/material.dart';
import 'package:restock/devices/presentation/utils/devices_theme.dart';

class DeviceKpiStrip extends StatelessWidget {
  const DeviceKpiStrip({
    super.key,
    required this.total,
    required this.configuredOrActive,
    required this.pendingSetup,
    required this.inactive,
  });

  final int total;
  final int configuredOrActive;
  final int pendingSetup;
  final int inactive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DevicesTheme.sidePadding,
        vertical: 12,
      ),
      child: Row(
        children: [
          _KpiCard(label: 'All', value: total, highlight: true),
          const SizedBox(width: 8),
          _KpiCard(label: 'Active', value: configuredOrActive),
          const SizedBox(width: 8),
          _KpiCard(label: 'Pending', value: pendingSetup),
          const SizedBox(width: 8),
          _KpiCard(label: 'Inactive', value: inactive),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final int value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: highlight
              ? DevicesTheme.greenPrimary
              : DevicesTheme.cardBackground,
          borderRadius: BorderRadius.circular(DevicesTheme.radiusMd),
          border: Border.all(
            color: highlight
                ? DevicesTheme.greenBorderDark
                : DevicesTheme.borderGray,
          ),
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: TextStyle(
                color: highlight ? Colors.white : DevicesTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: highlight
                    ? Colors.white.withValues(alpha: 0.8)
                    : DevicesTheme.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
