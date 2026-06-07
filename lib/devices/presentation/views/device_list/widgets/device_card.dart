import 'package:flutter/material.dart';
import 'package:restock/devices/domain/entities/device.dart';
import 'package:restock/devices/domain/entities/device_status.dart';
import 'package:restock/devices/presentation/utils/device_health_mock.dart';
import 'package:restock/devices/presentation/utils/devices_theme.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({
    super.key,
    required this.device,
    required this.onTap,
  });

  final Device device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final health = DeviceHealthMock.of(device.deviceId, device.status);

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _HealthBadge(health: health),
                const SizedBox(height: 4),
                _StatusDot(status: device.status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthBadge extends StatelessWidget {
  const _HealthBadge({required this.health});

  final DeviceHealth health;

  @override
  Widget build(BuildContext context) {
    final (bg, border, text) = switch (health) {
      DeviceHealth.healthy => (
          DevicesTheme.healthyBg,
          DevicesTheme.healthyBorder,
          DevicesTheme.healthyText,
        ),
      DeviceHealth.warm => (
          DevicesTheme.warmBg,
          DevicesTheme.warmBorder,
          DevicesTheme.warmText,
        ),
      DeviceHealth.critical => (
          DevicesTheme.criticalBg,
          DevicesTheme.criticalBorder,
          DevicesTheme.criticalText,
        ),
      DeviceHealth.offline => (
          DevicesTheme.offlineBg,
          DevicesTheme.offlineBorder,
          DevicesTheme.offlineText,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
      ),
      child: Text(
        DeviceHealthMock.label(health),
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

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});

  final DeviceStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      DeviceStatus.registered => (Colors.orange, 'REGISTERED'),
      DeviceStatus.configured => (DevicesTheme.greenPrimary, 'CONFIGURED'),
      DeviceStatus.active => (DevicesTheme.greenAccent, 'ACTIVE'),
      DeviceStatus.inactive => (DevicesTheme.textSecondary, 'INACTIVE'),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}
