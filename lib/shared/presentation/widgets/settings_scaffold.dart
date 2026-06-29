import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_bloc.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_state.dart';
import 'package:restock/resources/presentation/branches/branch_status/widgets/branch_status_summary.dart';
import 'package:restock/shared/presentation/utils/ui/theme.dart';
import 'package:restock/shared/presentation/widgets/app_bar.dart';
import 'package:restock/shared/presentation/widgets/settings_section_tabs.dart';

class SettingsScaffold extends StatelessWidget {
  const SettingsScaffold({
    required this.selectedSection,
    required this.child,
    super.key,
  });

  final SettingsSection selectedSection;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: const RestockAppBar(),
      body: Column(
        children: [
          SettingsSectionTabs(selectedSection: selectedSection),
          Expanded(child: child),
          if (selectedSection == SettingsSection.branches)
            BlocBuilder<BranchListBloc, BranchListState>(
              buildWhen: (prev, curr) => prev.branches != curr.branches,
              builder: (context, state) {
                if (state.branches.isEmpty) return const SizedBox.shrink();

                final total = state.branches.length;
                final active = state.branches
                    .where((branch) => branch.status.toLowerCase() == 'active')
                    .length;
                final inactive = state.branches
                    .where(
                      (branch) => branch.status.toLowerCase() == 'inactive',
                    )
                    .length;

                return BranchStatusSummary(
                  total: total,
                  active: active,
                  inactive: inactive,
                );
              },
            ),
        ],
      ),
    );
  }
}
