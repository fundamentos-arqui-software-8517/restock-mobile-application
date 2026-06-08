import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restock/devices/presentation/utils/devices_theme.dart';
import 'package:restock/devices/presentation/views/device_list/bloc/device_list_bloc.dart';
import 'package:restock/devices/presentation/views/device_list/bloc/device_list_event.dart';
import 'package:restock/devices/presentation/views/device_list/bloc/device_list_state.dart';
import 'package:restock/devices/presentation/views/device_list/widgets/device_card.dart';
import 'package:restock/devices/presentation/views/device_list/widgets/device_kpi_strip.dart';
import 'package:restock/devices/presentation/views/device_list/widgets/register_device_bottom_sheet.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/widgets/app_bar.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DevicesTheme.background,
      appBar: const RestockAppBar(),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          // Tab header
          SliverToBoxAdapter(
            child: Container(
              color: DevicesTheme.cardBackground,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: DevicesTheme.greenPrimary,
                          width: 2,
                        ),
                      ),
                    ),
                    child: const Text(
                      'DEVICES',
                      style: TextStyle(
                        color: DevicesTheme.greenPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Add Device button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                DevicesTheme.sidePadding,
                16,
                DevicesTheme.sidePadding,
                0,
              ),
              child: GestureDetector(
                onTap: () => showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BlocProvider.value(
                    value: context.read<DeviceListBloc>(),
                    child: const RegisterDeviceBottomSheet(),
                  ),
                ),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: DevicesTheme.greenPrimary,
                    borderRadius: BorderRadius.circular(
                      DevicesTheme.radiusSm,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Add Device',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                DevicesTheme.sidePadding,
                12,
                DevicesTheme.sidePadding,
                0,
              ),
              child: TextField(
                onChanged: (q) =>
                    context.read<DeviceListBloc>().add(SearchQueryChanged(q)),
                decoration: InputDecoration(
                  hintText: 'Search by MAC or alias…',
                  hintStyle: const TextStyle(
                    color: DevicesTheme.textSecondary,
                    fontSize: 13,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: DevicesTheme.textSecondary,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: DevicesTheme.cardBackground,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
                    borderSide: const BorderSide(color: DevicesTheme.borderGray),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
                    borderSide: const BorderSide(color: DevicesTheme.borderGray),
                  ),
                ),
              ),
            ),
          ),

          // KPI strip
          BlocBuilder<DeviceListBloc, DeviceListState>(
            buildWhen: (prev, curr) =>
                prev.totalCount != curr.totalCount ||
                prev.configuredOrActiveCount != curr.configuredOrActiveCount ||
                prev.pendingSetupCount != curr.pendingSetupCount ||
                prev.inactiveCount != curr.inactiveCount,
            builder: (context, state) => SliverToBoxAdapter(
              child: DeviceKpiStrip(
                total: state.totalCount,
                configuredOrActive: state.configuredOrActiveCount,
                pendingSetup: state.pendingSetupCount,
                inactive: state.inactiveCount,
              ),
            ),
          ),

          // Device list
          BlocBuilder<DeviceListBloc, DeviceListState>(
            builder: (context, state) {
              return switch (state.status) {
                Status.initial || Status.loading => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: DevicesTheme.greenPrimary,
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
                Status.failure => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
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
                            'Could not load devices',
                            style: TextStyle(
                              color: DevicesTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.errorMessage ??
                                'Please check your connection and try again.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: DevicesTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 28),
                          GestureDetector(
                            onTap: () => context
                                .read<DeviceListBloc>()
                                .add(const GetDevices()),
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
                ),
                Status.success when state.filteredDevices.isEmpty =>
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: DevicesTheme.cardBackground,
                              child: Icon(
                                Icons.scale_outlined,
                                color: DevicesTheme.textSecondary,
                                size: 36,
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'No Devices Yet',
                              style: TextStyle(
                                color: DevicesTheme.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Register your first device to start monitoring your inventory.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: DevicesTheme.textSecondary,
                                fontSize: 13,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Status.success => SliverList.separated(
                  itemCount: state.filteredDevices.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 4),
                  itemBuilder: (context, i) {
                    final device = state.filteredDevices[i];
                    return DeviceCard(
                      device: device,
                      onTap: () => context
                          .push('/devices/${device.deviceId}')
                          .then((_) {
                        if (context.mounted) {
                          context
                              .read<DeviceListBloc>()
                              .add(const GetDevices());
                        }
                      }),
                    );
                  },
                ),
              };
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
