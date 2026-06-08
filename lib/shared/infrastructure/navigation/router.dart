import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_bloc.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_event.dart';
import 'package:restock/devices/presentation/views/device_detail/device_detail_screen.dart';
import 'package:restock/devices/presentation/views/device_list/bloc/device_list_bloc.dart';
import 'package:restock/devices/presentation/views/device_list/bloc/device_list_event.dart';
import 'package:restock/devices/presentation/views/device_list/device_list_screen.dart';
import 'package:restock/iam/presentation/views/sign_in_form/bloc/sign_in_form_bloc.dart';
import 'package:restock/iam/presentation/views/sign_in_form/pages/sign_in_form_screen.dart';
import 'package:restock/injections.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_bloc.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_event.dart';
import 'package:restock/resources/presentation/branches/pages/branch_page.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_event.dart';
import 'package:restock/resources/presentation/inventory_management/pages/inventory_page.dart';
import 'package:restock/shared/infrastructure/services/auth_status_notifier.dart';
import '../../presentation/widgets/shell_scaffold.dart';

GoRouter buildRouter(AuthStatusNotifier authNotifier) => GoRouter(
  initialLocation: '/inventory',
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
              builder: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inventory',
              builder: (context, state) => BlocProvider<CustomSupplyListBloc>(
                create: (context) =>
                    serviceLocator<CustomSupplyListBloc>()
                      ..add(const GetCustomSuppliesByBranchId()),
                child: const InventoryPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/alerts',
              builder: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/devices',
              builder: (context, state) => BlocProvider<DeviceListBloc>(
                create: (_) => serviceLocator<DeviceListBloc>()
                  ..add(const GetDevices()),
                child: const DeviceListScreen(),
              ),
              routes: [
                GoRoute(
                  path: ':deviceId',
                  builder: (context, state) {
                    final deviceId = state.pathParameters['deviceId']!;
                    return BlocProvider<DeviceDetailBloc>(
                      create: (_) => serviceLocator<DeviceDetailBloc>()
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
            GoRoute(
              path: '/settings',
              builder: (_, _) => MultiBlocProvider(
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
                child: const BranchesPage(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
