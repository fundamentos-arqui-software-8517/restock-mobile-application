import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restock/shared/presentation/utils/ui/theme.dart';

enum SettingsSection { general, profile, branches }

class SettingsSectionTabs extends StatelessWidget {
  const SettingsSectionTabs({required this.selectedSection, super.key});

  final SettingsSection selectedSection;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: card,
      child: Row(
        children: [
          _TabItem(
            label: 'GENERAL',
            selected: selectedSection == SettingsSection.general,
            onTap: () => context.go('/settings/general'),
          ),
          _TabItem(
            label: 'PROFILE',
            selected: selectedSection == SettingsSection.profile,
            onTap: () => context.go('/settings/profile'),
          ),
          _TabItem(
            label: 'BRANCHES',
            selected: selectedSection == SettingsSection.branches,
            onTap: () => context.go('/settings'),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: selected ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? green : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? green : textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
          ),
        ),
      ),
    );
  }
}
