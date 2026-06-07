import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/devices/domain/entities/device_status.dart';
import 'package:restock/devices/presentation/utils/devices_theme.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_bloc.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_event.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_state.dart';
import 'package:restock/devices/presentation/views/device_detail/widgets/alert_thresholds_card.dart';
import 'package:restock/devices/presentation/views/device_detail/widgets/assigned_batch_card.dart';
import 'package:restock/devices/presentation/views/device_detail/widgets/assign_batch_bottom_sheet.dart';
import 'package:restock/devices/presentation/views/device_detail/widgets/danger_zone_card.dart';
import 'package:restock/devices/presentation/views/device_detail/widgets/unlink_confirm_bottom_sheet.dart';
import 'package:restock/injections.dart';
import 'package:restock/resources/application/custom_supply_facade_service.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class DeviceDetailScreen extends StatelessWidget {
  const DeviceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceDetailBloc, DeviceDetailState>(
      listenWhen: (prev, curr) =>
          prev.errorMessage != curr.errorMessage &&
          curr.errorMessage != null &&
          !curr.isSubmitting,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: DevicesTheme.criticalBorder,
          ),
        );
      },
      child: BlocBuilder<DeviceDetailBloc, DeviceDetailState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: DevicesTheme.background,
            appBar: AppBar(
              backgroundColor: DevicesTheme.headerDark,
              foregroundColor: Colors.white,
              title: Text(
                state.device?.description ?? 'Device Detail',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                if (state.device != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _StatusChip(status: state.device!.status),
                  ),
              ],
            ),
            body: switch (state.status) {
              Status.initial || Status.loading => const Center(
                child: CircularProgressIndicator(
                  color: DevicesTheme.greenPrimary,
                  strokeWidth: 2.5,
                ),
              ),
              Status.failure => Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.wifi_off_rounded,
                        color: DevicesTheme.criticalBorder,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Could not load device',
                        style: TextStyle(
                          color: DevicesTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage ?? 'Please try again.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: DevicesTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 28),
                      GestureDetector(
                        onTap: () => context
                            .read<DeviceDetailBloc>()
                            .add(
                              DeviceDetailFetched(state.device!.deviceId),
                            ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: DevicesTheme.greenPrimary,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(
                              DevicesTheme.radiusSm,
                            ),
                          ),
                          child: const Text(
                            'Try again',
                            style: TextStyle(
                              color: DevicesTheme.greenPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Status.success => _buildBody(context, state),
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, DeviceDetailState state) {
    final device = state.device!;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        // MAC header card
        Container(
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
          child: Row(
            children: [
              const Icon(
                Icons.scale_outlined,
                size: 20,
                color: DevicesTheme.textSecondary,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.macAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                      color: DevicesTheme.textPrimary,
                    ),
                  ),
                  if (device.firmwareVersion != null)
                    Text(
                      'FW ${device.firmwareVersion}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: DevicesTheme.textSecondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        AssignedBatchCard(
          device: device,
          onAssignBatch: () => _showAssignBatch(context),
        ),

        AlertThresholdsCard(device: device, threshold: state.threshold),

        DangerZoneCard(
          device: device,
          onUnlink: () => _showUnlinkConfirm(context, device.deviceId),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  void _showAssignBatch(BuildContext context) {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<DeviceDetailBloc>(),
        child: AssignBatchBottomSheet(
          customSupplyFacadeService:
              serviceLocator<CustomSupplyFacadeService>(),
        ),
      ),
    );
  }

  void _showUnlinkConfirm(BuildContext context, String deviceId) {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<DeviceDetailBloc>(),
        child: UnlinkConfirmBottomSheet(deviceId: deviceId),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final DeviceStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      DeviceStatus.registered => (Colors.orange, 'REGISTERED'),
      DeviceStatus.configured => (DevicesTheme.greenAccent, 'CONFIGURED'),
      DeviceStatus.active => (DevicesTheme.greenAccent, 'ACTIVE'),
      DeviceStatus.inactive => (DevicesTheme.textSecondary, 'INACTIVE'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
