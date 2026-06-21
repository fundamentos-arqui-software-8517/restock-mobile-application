import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restock/injections.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_bloc.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_event.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_state.dart';
import 'package:restock/resources/presentation/batches/batch_list/widgets/batch_action_bar.dart';
import 'package:restock/resources/presentation/batches/batch_list/widgets/batch_filter_row.dart';
import 'package:restock/resources/presentation/batches/batch_list/widgets/batch_list_view.dart';
import 'package:restock/resources/presentation/batches/batch_list/widgets/batch_overview_metrics.dart';
import 'package:restock/resources/presentation/batches/batch_list/widgets/batch_search_field.dart';
import 'package:restock/resources/presentation/batches/batch_transfer/bloc/batch_transfer_bloc.dart';
import 'package:restock/resources/presentation/batches/batch_transfer/bloc/batch_transfer_event.dart';
import 'package:restock/resources/presentation/batches/batch_transfer/widgets/batch_transfer_form.dart';
import 'package:restock/resources/presentation/batches/create_and_edit_batch/bloc/create_and_edit_batch_bloc.dart';
import 'package:restock/resources/presentation/batches/create_and_edit_batch/bloc/create_and_edit_batch_event.dart';
import 'package:restock/resources/presentation/batches/create_and_edit_batch/widgets/create_and_edit_batch_form.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/widgets/app_bar.dart';

class BatchesPage extends StatefulWidget {
  const BatchesPage({super.key});

  @override
  State<BatchesPage> createState() => _BatchesPageState();
}

class _BatchesPageState extends State<BatchesPage> {
  late final BranchFacadeService _branchFacadeService;

  @override
  void initState() {
    super.initState();
    _branchFacadeService = serviceLocator<BranchFacadeService>();
    _branchFacadeService.activeBranchIdListenable.addListener(
      _refreshForActiveBranch,
    );
  }

  @override
  void dispose() {
    _branchFacadeService.activeBranchIdListenable.removeListener(
      _refreshForActiveBranch,
    );
    super.dispose();
  }

  void _refreshForActiveBranch() {
    if (!mounted) return;
    context.read<BatchListBloc>().add(const BatchListStarted());
  }

  /// Opens the create/edit batch form in a bottom sheet. If a batch is successfully created or edited, the batch list is refreshed.
  Future<void> _openCreateAndEditBatchSheet(BuildContext context) async {
    final batchListBloc = context.read<BatchListBloc>();

    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider<CreateAndEditBatchBloc>(
        create: (_) =>
            serviceLocator<CreateAndEditBatchBloc>()
              ..add(const CreateAndEditBatchStarted()),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const CreateAndEditBatchForm(),
        ),
      ),
    );

    if (created == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        batchListBloc.add(const BatchListStarted());
      });
    }
  }

  /// Opens the batch transfer form in a bottom sheet. If a transfer is successfully created, the batch list is refreshed.
  Future<void> _openTransferBatchSheet(BuildContext context) async {
    final batchListBloc = context.read<BatchListBloc>();

    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider<BatchTransferBloc>(
        create: (_) =>
          serviceLocator<BatchTransferBloc>()
            ..add(const BatchTransferStarted()),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const BatchTransferForm(),
        ),
      ),
    );

    if (created == true) {
      batchListBloc.add(const BatchListStarted());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: const RestockAppBar(),
      body: BlocBuilder<BatchListBloc, BatchListState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: const Color(0xFF007A4D),
            onRefresh: () async {
              context.read<BatchListBloc>().add(const BatchListStarted());
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  sliver: SliverList.list(
                    children: state.requiresBranchSelection
                        ? const [_BranchSelectionRequiredMessage()]
                        : [
                            const Text(
                              'Batches',
                              style: TextStyle(
                                color: Color(0xFF0F1B2A),
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 18),
                            BatchSearchField(
                              onChanged: (query) => context
                                  .read<BatchListBloc>()
                                  .add(BatchSearchChanged(query)),
                            ),
                            const SizedBox(height: 18),
                            BatchActionBar(
                              onAddBatch: () =>
                                  _openCreateAndEditBatchSheet(context),
                              onTransfer: () =>
                                  _openTransferBatchSheet(context),
                              onCustomSupplies: () =>
                                  context.go('/supplies'),
                            ),
                            const SizedBox(height: 18),
                            BatchOverviewMetrics(
                              totalActiveBatches: state.batches.length,
                              nearExpiryCount: state.nearExpiryCount,
                            ),
                            const SizedBox(height: 16),
                            BatchFilterRow(
                              stockFilter: state.stockFilter,
                              categoryLabel: state.selectedCategoryLabel,
                              categoryOptions: state.categoryOptions,
                              selectedCategoryKey: state.categoryFilterKey,
                              onStockFilterChanged: (filter) => context
                                  .read<BatchListBloc>()
                                  .add(BatchStockFilterChanged(filter)),
                              onCategoryFilterChanged: (categoryKey) => context
                                  .read<BatchListBloc>()
                                  .add(BatchCategoryFilterChanged(categoryKey)),
                            ),
                            const SizedBox(height: 20),
                            _BatchListBody(state: state),
                          ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BranchSelectionRequiredMessage extends StatelessWidget {
  const _BranchSelectionRequiredMessage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.62,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFE8FFF6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFB7F4DD)),
              ),
              child: const Icon(
                Icons.storefront_outlined,
                color: Color(0xFF007A4D),
                size: 34,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No active branch selected',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0F1B2A),
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                'Select a branch in Settings to view inventory.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BatchListBody extends StatelessWidget {
  const _BatchListBody({required this.state});

  final BatchListState state;

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      Status.initial || Status.loading => const Padding(
        padding: EdgeInsets.symmetric(vertical: 56),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007A4D)),
          ),
        ),
      ),
      Status.failure => Padding(
        padding: const EdgeInsets.symmetric(vertical: 42),
        child: Center(
          child: Text(
            state.message ?? 'Error loading batches',
            style: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      Status.success => BatchListView(
        batches: state.filteredBatches,
        isSearching: state.isFiltering,
      ),
    };
  }
}
