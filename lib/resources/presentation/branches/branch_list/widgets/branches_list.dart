import 'package:flutter/material.dart';
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/presentation/branches/branch_list/widgets/branch_card.dart';
import 'package:restock/shared/presentation/utils/ui/theme.dart';

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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: green.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: const Column(
                  children: [
                    CircleAvatar(
                      radius: 21,
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.add_circle_outline,
                          color: green, size: 42),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '+ Expand Network',
                      style: TextStyle(
                        color: green,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Add a new operational facility to your directory',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}