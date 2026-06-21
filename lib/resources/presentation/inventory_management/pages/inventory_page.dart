import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/injections.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/resources/presentation/custom_supplies/create_and_edit_custom_supply/bloc/create_and_edit_custom_supply_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/create_and_edit_custom_supply/widgets/create_custom_supply_form.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_event.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_state.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/widgets/custom_supply_list.dart';
import 'package:restock/resources/presentation/inventory_management/widgets/empty_inventory_view.dart';
import 'package:restock/shared/presentation/widgets/app_bar.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

/// The main page for inventory management, displaying the list of custom supplies.
///
/// Handles loading, error, and empty states for the inventory list using BlocBuilder to listen to the CustomSupplyListBloc.
class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
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
    context.read<CustomSupplyListBloc>().add(
      const GetCustomSuppliesByBranchId(),
    );
  }

  Future<void> _openCreateSheet(BuildContext context) async {
    final listBloc = context.read<CustomSupplyListBloc>();

    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider<CreateCustomSupplyBloc>(
        create: (_) => serviceLocator<CreateCustomSupplyBloc>(),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const CreateCustomSupplyForm(),
        ),
      ),
    );

    if (created == true) {
      listBloc.add(const GetCustomSuppliesByBranchId());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: const RestockAppBar(),
      body: BlocBuilder<CustomSupplyListBloc, CustomSupplyListState>(
        builder: (context, state) {
          switch (state.status) {
            case Status.initial:
            case Status.loading:
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E6F40)),
                ),
              );
            case Status.failure:
              return Center(
                child: Text(
                  state.message ?? 'Error loading inventory',
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            case Status.success:
              if (state.customSupplies.isEmpty) {
                return EmptyInventoryView(
                  onAddSupply: () => _openCreateSheet(context),
                );
              }
              return CustomSupplyListView(
                customSupplies: state.filteredCustomSupplies,
                isSearching: state.isSearching,
              );
          }
        },
      ),
    );
  }
}
