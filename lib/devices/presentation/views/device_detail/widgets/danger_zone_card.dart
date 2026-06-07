import 'package:flutter/material.dart';
import 'package:restock/devices/domain/entities/device.dart';
import 'package:restock/devices/presentation/utils/devices_theme.dart';

class DangerZoneCard extends StatelessWidget {
  const DangerZoneCard({
    super.key,
    required this.device,
    required this.onUnlink,
  });

  final Device device;
  final VoidCallback onUnlink;

  @override
  Widget build(BuildContext context) {
    if (!device.isOnboardingComplete) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: DevicesTheme.sidePadding,
        vertical: 6,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DevicesTheme.cardBackground,
        borderRadius: BorderRadius.circular(DevicesTheme.radiusMd),
        border: Border.all(color: DevicesTheme.criticalBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 18,
                color: DevicesTheme.criticalBorder,
              ),
              SizedBox(width: 8),
              Text(
                'Danger Zone',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: DevicesTheme.criticalBorder,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Unlinking will set this device to INACTIVE. This action cannot be undone without contacting support.',
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
            child: OutlinedButton(
              onPressed: onUnlink,
              style: OutlinedButton.styleFrom(
                foregroundColor: DevicesTheme.criticalBorder,
                side: const BorderSide(color: DevicesTheme.criticalBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
                ),
              ),
              child: const Text(
                'Unlink Supply Keeper',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
