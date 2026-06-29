import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/analytics/presentation/views/dashboard/bloc/dashboard_bloc.dart';
import 'package:restock/analytics/presentation/views/dashboard/bloc/dashboard_event.dart';
import 'package:restock/analytics/presentation/views/dashboard/bloc/dashboard_state.dart';
import 'package:restock/analytics/presentation/views/dashboard/views/empty_card.dart';
import 'package:restock/analytics/presentation/views/dashboard/views/error_banner.dart';
import 'package:restock/analytics/presentation/views/dashboard/views/dashboard_kpi_row.dart';
import 'package:restock/analytics/presentation/views/dashboard/views/dashboard_welcome.dart';
import 'package:restock/analytics/presentation/views/dashboard/views/stock_discrepancy_table.dart';
import 'package:restock/devices/presentation/views/device_list/bloc/device_list_bloc.dart';
import 'package:restock/devices/presentation/views/device_list/bloc/device_list_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/widgets/app_bar.dart';

import '../../../../../shared/presentation/utils/ui/theme.dart';
import '../views/section_header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: analyticsBackground,
      appBar: const RestockAppBar(),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.status == Status.loading && !state.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: green, strokeWidth: 3),
            );
          }

          return RefreshIndicator(
            color: green,
            onRefresh: () async {
              context.read<DashboardBloc>().add(const DashboardRefreshed());
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                if (state.status == Status.failure)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                    sliver: SliverToBoxAdapter(
                      child: ErrorBanner(
                        message:
                            state.errorMessage ??
                            'Could not load overview analytics',
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  sliver: const SliverToBoxAdapter(child: DashboardWelcome()),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                  sliver: SliverToBoxAdapter(
                    child: BlocBuilder<DeviceListBloc, DeviceListState>(
                      builder: (context, deviceState) {
                        return DashboardKpiRow(
                          state: state,
                          activeScales: deviceState.configuredOrActiveCount,
                        );
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
                  sliver: const SliverToBoxAdapter(
                    child: SectionHeader(title: 'Stock Discrepancies'),
                  ),
                ),
                if (state.discrepancies.isEmpty)
                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(24, 14, 24, 0),
                    sliver: SliverToBoxAdapter(
                      child: EmptyCard(message: 'No stock discrepancies found'),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                    sliver: SliverToBoxAdapter(
                      child: StockDiscrepancyTable(
                        discrepancies: state.discrepancies,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 28)),
              ],
            ),
          );
        },
      ),
    );
  }
}
