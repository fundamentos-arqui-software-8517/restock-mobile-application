import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/devices/domain/entities/device.dart';
import 'package:restock/devices/domain/entities/device_threshold.dart';
import 'package:restock/devices/presentation/utils/devices_theme.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_bloc.dart';
import 'package:restock/devices/presentation/views/device_detail/widgets/edit_thresholds_bottom_sheet.dart';

class AlertThresholdsCard extends StatelessWidget {
  const AlertThresholdsCard({
    super.key,
    required this.device,
    required this.threshold,
  });

  final Device device;
  final DeviceThreshold? threshold;

  @override
  Widget build(BuildContext context) {
    final locked = !device.hasBatch;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: DevicesTheme.sidePadding,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: locked ? DevicesTheme.background : DevicesTheme.cardBackground,
        borderRadius: BorderRadius.circular(DevicesTheme.radiusMd),
        border: Border.all(color: DevicesTheme.borderGray),
      ),
      child: locked
          ? const _LockedState()
          : threshold == null
          ? _EmptyState(onTap: () => _openSheet(context))
          : _FilledState(
              threshold: threshold!,
              onEdit: () => _openSheet(context, existing: threshold),
            ),
    );
  }

  void _openSheet(BuildContext context, {DeviceThreshold? existing}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => BlocProvider.value(
          value: context.read<DeviceDetailBloc>(),
          child: EditThresholdsBottomSheet(existing: existing),
        ),
      ),
    );
  }
}

class _LockedState extends StatelessWidget {
  const _LockedState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: const [
          Icon(
            Icons.notifications_none_outlined,
            size: 18,
            color: DevicesTheme.textSecondary,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Alert Thresholds — assign a batch first',
              style: TextStyle(
                fontSize: 13,
                color: DevicesTheme.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Icon(Icons.lock_outline, size: 16, color: DevicesTheme.textSecondary),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.notifications_active_outlined,
                size: 18,
                color: DevicesTheme.greenPrimary,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Alert Thresholds',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: DevicesTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Configure stock, temperature, and humidity limits to complete setup.',
            style: TextStyle(fontSize: 13, color: DevicesTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: DevicesTheme.greenPrimary,
                borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
              ),
              child: const Text(
                'Set Thresholds',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilledState extends StatelessWidget {
  const _FilledState({required this.threshold, required this.onEdit});

  final DeviceThreshold threshold;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_active_outlined,
                size: 18,
                color: DevicesTheme.greenPrimary,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Alert Thresholds',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: DevicesTheme.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onEdit,
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: DevicesTheme.greenPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _Row('Min stock', '${threshold.minStock}'),
          _Row('Max stock', '${threshold.maxStock}'),
          _Row('Anomaly threshold', '${threshold.anomalyThreshold}'),
          if (threshold.minTemperature != null)
            _Row('Min temp', '${threshold.minTemperature} °C'),
          if (threshold.maxTemperature != null)
            _Row('Max temp', '${threshold.maxTemperature} °C'),
          if (threshold.minHumidity != null)
            _Row('Min humidity', '${threshold.minHumidity}%'),
          if (threshold.maxHumidity != null)
            _Row('Max humidity', '${threshold.maxHumidity}%'),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: DevicesTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: DevicesTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
