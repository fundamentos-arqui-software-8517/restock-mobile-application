import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restock/analytics/presentation/views/dashboard/bloc/dashboard_bloc.dart';
import 'package:restock/analytics/presentation/views/dashboard/bloc/dashboard_event.dart';
import 'package:restock/analytics/presentation/views/dashboard/pages/dashboard_screen.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_bloc.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_event.dart';
import 'package:restock/devices/presentation/views/device_detail/device_detail_screen.dart';
import 'package:restock/devices/presentation/views/device_list/bloc/device_list_bloc.dart';
import 'package:restock/devices/presentation/views/device_list/bloc/device_list_event.dart';
import 'package:restock/devices/presentation/views/device_list/device_list_screen.dart';
import 'package:restock/iam/presentation/views/sign_in_form/bloc/sign_in_form_bloc.dart';
import 'package:restock/iam/presentation/views/sign_in_form/pages/sign_in_form_screen.dart';
import 'package:restock/injections.dart';
import 'package:restock/profiles/presentation/general/profile_general_page.dart';
import 'package:restock/profiles/presentation/profile/profile_page.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/resources/application/custom_supply_facade_service.dart';
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/domain/entities/batch.dart';
import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/resources/presentation/batches/batch_detail/widgets/batch_detail_screen.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_bloc.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_event.dart';
import 'package:restock/resources/presentation/batches/pages/batches_page.dart';
import 'package:restock/resources/presentation/branches/branch_detail/bloc/branch_detail_bloc.dart';
import 'package:restock/resources/presentation/branches/branch_detail/bloc/branch_detail_event.dart';
import 'package:restock/resources/presentation/branches/branch_detail/widgets/branch_detail_screen.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_bloc.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_event.dart';
import 'package:restock/resources/presentation/branches/pages/branch_page.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_event.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_summary/bloc/custom_supply_summary_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_summary/bloc/custom_supply_summary_event.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_summary/widgets/custom_supply_summary_screen.dart';
import 'package:restock/resources/presentation/inventory_management/pages/inventory_page.dart';
import 'package:restock/shared/infrastructure/services/auth_status_notifier.dart';
import 'package:restock/shared/presentation/widgets/settings_scaffold.dart';
import 'package:restock/shared/presentation/widgets/settings_section_tabs.dart';
import '../../presentation/widgets/shell_scaffold.dart';

GoRouter buildRouter(AuthStatusNotifier authNotifier) => GoRouter(
  initialLocation: '/overview',
  refreshListenable: authNotifier,
  redirect: (context, state) {
    final isLoggedIn = authNotifier.isAuthenticated;
    final isOnLogin = state.matchedLocation == '/login';

    if (!isLoggedIn && !isOnLogin) return '/login';
    if (isLoggedIn && isOnLogin) return '/inventory';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (_, _) => BlocProvider<SignInBloc>(
        create: (_) => serviceLocator<SignInBloc>(),
        child: const SignInPage(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ShellScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/overview',
              builder: (_, _) => MultiBlocProvider(
                providers: [
                  BlocProvider<DashboardBloc>(
                    create: (_) =>
                        serviceLocator<DashboardBloc>()
                          ..add(const DashboardStarted()),
                  ),
                  BlocProvider<DeviceListBloc>(
                    create: (_) =>
                        serviceLocator<DeviceListBloc>()
                          ..add(const GetDevices()),
                  ),
                ],
                child: const DashboardScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/supplies',
              builder: (context, state) => BlocProvider<CustomSupplyListBloc>(
                create: (context) =>
                    serviceLocator<CustomSupplyListBloc>()
                      ..add(const GetCustomSuppliesByBranchId()),
                child: const InventoryPage(),
              ),
              routes: [
                GoRoute(
                  path: ':customSupplyId',
                  builder: (context, state) {
                    final customSupplyId =
                        state.pathParameters['customSupplyId']!;
                    final customSupply = state.extra;

                    return BlocProvider<CustomSupplySummaryBloc>(
                      create: (_) =>
                          CustomSupplySummaryBloc(
                            customSupplyFacadeService:
                                serviceLocator<CustomSupplyFacadeService>(),
                          )..add(
                            CustomSupplySummaryStarted(
                              customSupplyId: customSupplyId,
                              initialCustomSupply: customSupply is CustomSupply
                                  ? customSupply
                                  : null,
                            ),
                          ),
                      child: const CustomSupplySummaryScreen(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inventory',
              builder: (context, state) => BlocProvider<BatchListBloc>(
                create: (context) =>
                    serviceLocator<BatchListBloc>()
                      ..add(const BatchListStarted()),
                child: const BatchesPage(),
              ),
              routes: [
                GoRoute(
                  path: ':batchId',
                  builder: (context, state) {
                    final batch = state.extra;

                    return BatchDetailScreen(
                      batch: batch is Batch
                          ? batch
                          : const Batch(
                              id: '',
                              code: '',
                              currentStock: 0,
                              unitMeasurement: '',
                              unitMeasurementAbbreviation: '',
                              customSupplyId: '',
                              branchId: '',
                              accountId: '',
                            ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/devices',
              builder: (context, state) => BlocProvider<DeviceListBloc>(
                create: (_) =>
                    serviceLocator<DeviceListBloc>()..add(const GetDevices()),
                child: const DeviceListScreen(),
              ),
              routes: [
                GoRoute(
                  path: ':deviceId',
                  builder: (context, state) {
                    final deviceId = state.pathParameters['deviceId']!;
                    return BlocProvider<DeviceDetailBloc>(
                      create: (_) =>
                          serviceLocator<DeviceDetailBloc>()
                            ..add(DeviceDetailFetched(deviceId)),
                      child: const DeviceDetailScreen(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            ShellRoute(
              builder: (context, state, child) => MultiBlocProvider(
                providers: [
                  RepositoryProvider<BranchFacadeService>(
                    create: (_) => serviceLocator<BranchFacadeService>(),
                  ),
                  BlocProvider<BranchListBloc>(
                    create: (_) =>
                        serviceLocator<BranchListBloc>()
                          ..add(const GetBranches()),
                  ),
                ],
                child: SettingsScaffold(
                  selectedSection: _settingsSectionFor(state.uri.path),
                  child: child,
                ),
              ),
              routes: [
                GoRoute(
                  path: '/settings',
                  pageBuilder: (_, _) =>
                      const NoTransitionPage(child: BranchesPage()),
                ),
                GoRoute(
                  path: '/settings/general',
                  pageBuilder: (_, _) =>
                      const NoTransitionPage(child: ProfileGeneralPage()),
                ),
                GoRoute(
                  path: '/settings/profile',
                  pageBuilder: (_, _) =>
                      const NoTransitionPage(child: ProfilePage()),
                ),
              ],
            ),
            GoRoute(
              path: '/settings/:branchId',
              builder: (context, state) {
                final branchId = state.pathParameters['branchId']!;
                final branch = state.extra;

                return BlocProvider<BranchDetailBloc>(
                  create: (_) => serviceLocator<BranchDetailBloc>()
                    ..add(
                      BranchDetailFetched(
                        branchId,
                        initialBranch: branch is Branch ? branch : null,
                      ),
                    ),
                  child: const BranchDetailScreen(),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

SettingsSection _settingsSectionFor(String path) {
  return switch (path) {
    '/settings/general' => SettingsSection.general,
    '/settings/profile' => SettingsSection.profile,
    _ => SettingsSection.branches,
  };
}
