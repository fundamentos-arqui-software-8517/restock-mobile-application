import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/injections.dart';
import 'package:restock/resources/application/supply_facade_service.dart';
import 'package:restock/resources/domain/entities/supply.dart';
import 'package:restock/resources/presentation/supplies/supply_list/bloc/supplies_list_bloc.dart';
import 'package:restock/resources/presentation/supplies/supply_list/bloc/supplies_list_event.dart';
import 'package:restock/resources/presentation/supplies/supply_list/bloc/supplies_list_state.dart';
import 'package:restock/resources/presentation/supplies/supply_list/widgets/selected_supply.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class SupplySelectorField extends StatelessWidget {
  const SupplySelectorField({
    super.key,
    required this.onChanged,
    this.value,
    this.label = 'SUPPLY',
    this.enabled = true,
  });

  final Supply? value;
  final ValueChanged<Supply?> onChanged;
  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SuppliesListBloc(
        supplyFacadeService: serviceLocator<SupplyFacadeService>(),
      )..add(const GetSupplies()),
      child: _SupplySelectorContent(
        value: value,
        label: label,
        enabled: enabled,
        onChanged: onChanged,
      ),
    );
  }
}

class _SupplySelectorContent extends StatelessWidget {
  const _SupplySelectorContent({
    this.value,
    required this.onChanged,
    this.label = 'SUPPLY',
    this.enabled = true,
  });

  final Supply? value;
  final ValueChanged<Supply?> onChanged;
  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuppliesListBloc, SuppliesListState>(
      builder: (context, state) {
        final isLoadingSupplies = state.status == Status.loading;
        final hasFailed = state.status == Status.failure;
        final supplies = state.supplies;
        final selectedSupply = value;
        final dropdownSupplies =
            selectedSupply != null && !supplies.contains(selectedSupply)
            ? [selectedSupply, ...supplies]
            : supplies;

        return DropdownButtonFormField<Supply>(
          initialValue: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF5A6472),
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          onChanged:
              enabled &&
                  !isLoadingSupplies &&
                  !hasFailed &&
                  dropdownSupplies.isNotEmpty
              ? onChanged
              : null,
          selectedItemBuilder: (context) => dropdownSupplies
              .map(
                (supply) =>
                    SelectedSupply(supply: supply, isPlaceholder: false),
              )
              .toList(),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: Color(0xFF5A6472),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
            hintText: _hintText(
              isLoading: isLoadingSupplies,
              hasFailed: hasFailed,
              isEmpty: supplies.isEmpty,
            ),
            hintStyle: const TextStyle(
              color: Color(0xFF9AA5B4),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: Container(
              width: 42,
              height: 42,
              margin: const EdgeInsets.fromLTRB(10, 8, 8, 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5EE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: Color(0xFF2D6A4F),
                size: 20,
              ),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFF0F0F0),
            contentPadding: const EdgeInsets.fromLTRB(0, 14, 12, 14),
            suffixIcon: isLoadingSupplies
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Color(0xFF2D6A4F),
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : null,
            helperText: hasFailed
                ? state.message ?? 'Failed to load supplies'
                : null,
            helperStyle: TextStyle(
              color: hasFailed
                  ? const Color(0xFFE24B4A)
                  : const Color(0xFF5A6472),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFDDE1E7),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF2D6A4F),
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFDDE1E7),
                width: 1.2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFE24B4A),
                width: 1.2,
              ),
            ),
          ),
          items: dropdownSupplies
              .map(
                (supply) => DropdownMenuItem<Supply>(
                  value: supply,
                  child: SupplyOption(supply: supply),
                ),
              )
              .toList(),
        );
      },
    );
  }

  String _hintText({
    required bool isLoading,
    required bool hasFailed,
    required bool isEmpty,
  }) {
    if (isLoading) return 'Loading supplies...';
    if (hasFailed) return 'Supplies unavailable';
    if (isEmpty) return 'No supplies available';
    return 'Select a supply';
  }
}
