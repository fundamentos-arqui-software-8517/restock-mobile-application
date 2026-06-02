import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_bloc.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_event.dart';
import 'package:restock/resources/presentation/branches/branch_list/widgets/branch_image.dart';
import 'package:restock/resources/presentation/branches/branch_status/bloc/branch_status_bloc.dart';
import 'package:restock/resources/presentation/branches/create_and_edit_branch/blocs/create_and_edit_branch_bloc.dart';
import 'package:restock/resources/presentation/branches/create_and_edit_branch/widgets/create_and_edit_form.dart';
import 'package:restock/shared/presentation/utils/ui/theme.dart';

/// A widget that represents a card displaying information about a branch, including its image, name, and address. The card is interactive, allowing users to long-press to open an edit sheet where they can modify the branch's details. The edit sheet uses the [CreateAndEditBranchBloc] to manage the state of the form and handle updates to the branch information.
class BranchCard extends StatelessWidget {
  const BranchCard({super.key, required this.branch});

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _openEditSheet(context),
      child: Container(
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BranchImage(imageUrl: branch.imageUrl, status: branch.status),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branch.name,
                    style: const TextStyle(
                      color: textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: textSecondary,
                        size: 13,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          branch.fullAddress,
                          style: const TextStyle(
                            color: textSecondary,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openEditSheet(BuildContext context) async {
    final branchListBloc = context.read<BranchListBloc>();

    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CreateAndEditBranchBloc(
              branchFacadeService: context.read<BranchFacadeService>(),
              branch: branch,
            ),
          ),
          BlocProvider(
            create: (_) => UpdateBranchStatusBloc(
              branchFacadeService: context.read<BranchFacadeService>(),
            ),
          ),
        ],
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: CreateAndEditBranchPage(branch: branch),
        ),
      ),
    );

    if (updated == true) {
      branchListBloc.add(const GetBranches());
    }
  }
}
