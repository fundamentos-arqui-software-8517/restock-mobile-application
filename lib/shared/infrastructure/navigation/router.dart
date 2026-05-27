import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restock/injections.dart';
import 'package:restock/resources/presentation/custom_supply_list/bloc/custom_supply_list_event.dart';
import 'package:restock/resources/presentation/inventory_management/pages/inventory_page.dart';
import '../../presentation/widgets/shell_scaffold.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/presentation/custom_supply_list/bloc/custom_supply_list_bloc.dart';

/// This file defines the application's routing configuration using the GoRouter package. It sets up the routes for different pages in the app, including the inventory page, and uses a shell scaffold to provide a consistent layout across all pages.
final GoRouter router = GoRouter(
  initialLocation: '/inventory',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ShellScaffold(
          navigationShell: navigationShell,
        );
      },
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
                create: (context) => serviceLocator<CustomSupplyListBloc>()
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
              builder: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ],
    ),
  ],
);