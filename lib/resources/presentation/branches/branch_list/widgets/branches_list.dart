import 'package:flutter/material.dart';
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/presentation/branches/branch_list/widgets/branch_card.dart';

/// A widget that displays a list of branches in a scrollable view. It uses a [SliverList] to display each branch as a [BranchCard], and includes padding and spacing between the cards. This widget is typically used within a [CustomScrollView] to allow for flexible scrolling behavior.
class BranchesList extends StatelessWidget {
  const BranchesList({super.key, required this.branches});

  final List<Branch> branches;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList.separated(
            itemCount: branches.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, i) => BranchCard(branch: branches[i]),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 28),
              ),
            ),
          ),
        ),
      ],
    );
  }
}