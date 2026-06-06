import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/injections.dart';
import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/resources/presentation/custom_supplies/create_and_edit_custom_supply/bloc/create_and_edit_custom_supply_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/create_and_edit_custom_supply/widgets/create_custom_supply_form.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_event.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/widgets/custom_supply_card.dart';

/// A widget that displays a list of custom supplies in a grid format, along with a search bar and an option to add new supplies.
///
/// The [CustomSupplyListView] takes a list of [CustomSupply] objects and renders them in a visually appealing way, allowing users to easily browse and manage their custom supplies. The search bar at the top allows users to filter the list of supplies, while the "Add Custom Supply" button provides a convenient way to add new items to the list. Each supply is displayed using the [SupplyItemCard] widget, which shows relevant information about the supply in a card format.
class CustomSupplyListView extends StatelessWidget {
  const CustomSupplyListView({required this.customSupplies, super.key});

  final List<CustomSupply> customSupplies;

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search supply...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E6F40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => _openCreateSheet(context),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add Custom Supply',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              itemCount: customSupplies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.84,
              ),
              itemBuilder: (context, index) {
                final supply = customSupplies[index];
                return SupplyItemCard(supply: supply);
              },
            ),
          ),
        ],
      ),
    );
  }
}
