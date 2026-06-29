import 'package:flutter/material.dart';
import 'package:restock/devices/domain/entities/device.dart';
import 'package:restock/devices/domain/entities/device_status.dart';
import 'package:restock/devices/presentation/utils/devices_theme.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({super.key, required this.device, required this.onTap});

  final Device device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: DevicesTheme.sidePadding,
          vertical: 4,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: DevicesTheme.cardBackground,
          borderRadius: BorderRadius.circular(DevicesTheme.radiusMd),
          border: Border.all(color: DevicesTheme.borderGray),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: DevicesTheme.background,
                borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
                border: Border.all(color: DevicesTheme.borderGray),
              ),
              child: const Icon(
                Icons.scale_outlined,
                size: 20,
                color: DevicesTheme.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.description,
                    style: const TextStyle(
                      color: DevicesTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    device.macAddress,
                    style: const TextStyle(
                      color: DevicesTheme.textSecondary,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _StatusBadge(status: device.status),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final DeviceStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, border, text, label) = switch (status) {
      DeviceStatus.registered => (
        DevicesTheme.offlineBg,
        DevicesTheme.offlineBorder,
        DevicesTheme.offlineText,
        'REGISTERED',
      ),
      DeviceStatus.configured => (
        DevicesTheme.warmBg,
        DevicesTheme.warmBorder,
        DevicesTheme.warmText,
        'CONFIGURED',
      ),
      DeviceStatus.calibrated || DeviceStatus.active => (
        DevicesTheme.healthyBg,
        DevicesTheme.healthyBorder,
        DevicesTheme.healthyText,
        status == DeviceStatus.calibrated ? 'CALIBRATED' : 'ACTIVE',
      ),
      DeviceStatus.inactive => (
        DevicesTheme.offlineBg,
        DevicesTheme.offlineBorder,
        DevicesTheme.offlineText,
        'INACTIVE',
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
