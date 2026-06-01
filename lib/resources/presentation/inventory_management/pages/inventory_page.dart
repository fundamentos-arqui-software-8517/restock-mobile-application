import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_state.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/widgets/custom_supply_list.dart';
import 'package:restock/resources/presentation/inventory_management/widgets/empty_inventory_view.dart';
import 'package:restock/shared/presentation/widgets/app_bar.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

/// The main page for inventory management, displaying the list of custom supplies.
/// 
/// Handles loading, error, and empty states for the inventory list using BlocBuilder to listen to the CustomSupplyListBloc.
class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: const RestockAppBar(
      ),
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
                return const EmptyInventoryView();
              }
              return CustomSupplyListView(customSupplies: state.customSupplies);
          }
        },
      ),
    );
  }
}