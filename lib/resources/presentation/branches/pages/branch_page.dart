import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_bloc.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_event.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_state.dart';
import 'package:restock/resources/presentation/branches/branch_list/widgets/branches_list.dart';

import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/utils/ui/theme.dart';
import 'package:restock/shared/presentation/widgets/app_bar.dart';

class BranchesPage extends StatelessWidget {
  const BranchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<BranchListBloc>().add(const GetBranches());

    return Scaffold(
      backgroundColor: background,
      appBar: const RestockAppBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          
          SliverToBoxAdapter(
            child: Container(
              color: card,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: green, width: 2),
                      ),
                    ),
                    child: const Text(
                      'BRANCHES',
                      style: TextStyle(
                        color: green,
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

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Color(0xFF0F1520), size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Add Branch',
                        style: TextStyle(
                          color: Color(0xFF0F1520),
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


          BlocBuilder<BranchListBloc, BranchListState>(
            builder: (context, state) {
              return switch (state.status) {
                Status.initial || Status.loading => const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: green,
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
                            const Icon(Icons.wifi_off_rounded,
                                color: red, size: 48),
                            const SizedBox(height: 16),
                            const Text(
                              'Could not load branches',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message ??
                                  'Please check your connection and try again.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: textSecondary, fontSize: 13),
                            ),
                            const SizedBox(height: 28),
                            GestureDetector(
                              onTap: () => context
                                  .read<BranchListBloc>()
                                  .add(const GetBranches()),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 12),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: green, width: 1.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Try again',
                                  style: TextStyle(
                                    color: green,
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
                Status.success when state.branches.isEmpty =>
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
                              backgroundColor: card,
                              child: Icon(
                                Icons.business_outlined,
                                color: textSecondary,
                                size: 36,
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'No Branches Yet',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Your network is empty. Add your first branch to start managing your operations.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 13,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Status.success => BranchesList(branches: state.branches),
              };
            },
          ),
        ],
      ),
    );
  }
}