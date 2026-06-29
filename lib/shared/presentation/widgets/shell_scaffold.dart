import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A custom Scaffold widget that serves as the main shell for the Restock application, providing a consistent layout and navigation structure.
///
/// This Scaffold includes a bottom navigation bar with icons and labels for different sections of the app, and it uses a StatefulNavigationShell to manage the navigation state across different branches.
class ShellScaffold extends StatelessWidget {
  const ShellScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const Color _bg = Color(0xFF151C2A);
  static const Color _active = Color(0xFF4ECCA3);
  static const Color _inactive = Color(0xFF5A6272);

  static const _items = [
    (Icons.dashboard_outlined, 'Overview'),
    (Icons.inventory_2_outlined, 'Supplies'),
    (Icons.inventory_outlined, 'Inventory'),
    (Icons.developer_board_outlined, 'Devices'),
    (Icons.settings_outlined, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: navigationShell,
      bottomNavigationBar: Container(
        color: _bg,
        child: SafeArea(
          top: false,
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (i) {
                final isActive = i == navigationShell.currentIndex;
                final color = isActive ? _active : _inactive;

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => navigationShell.goBranch(
                      i,
                      initialLocation: i == navigationShell.currentIndex,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(_items[i].$1, color: color, size: 24),
                          const SizedBox(height: 4),
                          Text(
                            _items[i].$2,
                            style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
