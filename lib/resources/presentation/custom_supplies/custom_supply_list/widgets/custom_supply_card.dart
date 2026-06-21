import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restock/injections.dart';
import 'package:restock/resources/application/custom_supply_facade_service.dart';
import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/resources/presentation/custom_supplies/create_and_edit_custom_supply/bloc/create_and_edit_custom_supply_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/create_and_edit_custom_supply/widgets/create_custom_supply_form.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_event.dart';
import 'package:restock/shared/presentation/widgets/network_aware_image.dart';

/// A card widget to display a supply item in the custom supply list.
///
/// Displays the supply's image, category, name, unit price, and unit of measure.
class SupplyItemCard extends StatelessWidget {
  const SupplyItemCard({required this.supply, super.key});

  final CustomSupply supply;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push('/supplies/${supply.customSupplyId}', extra: supply),
      onLongPress: () => _openEditSheet(context),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFF3F4F6),
                  child: NetworkAwareImage(
                    imageUrl: supply.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: const Icon(
                      Icons.inventory_2_outlined,
                      color: Color(0xFF9AA5B4),
                      size: 44,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    supply.category.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    supply.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'UnitPrice: ${supply.unitPrice.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
    final listBloc = context.read<CustomSupplyListBloc>();

    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider<CreateCustomSupplyBloc>(
        create: (_) => CreateCustomSupplyBloc(
          customSupplyFacadeService:
              serviceLocator<CustomSupplyFacadeService>(),
          customSupply: supply,
        ),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const CreateCustomSupplyForm(),
        ),
      ),
    );

    if (updated == true) {
      listBloc.add(const GetCustomSuppliesByBranchId());
    }
  }
}
