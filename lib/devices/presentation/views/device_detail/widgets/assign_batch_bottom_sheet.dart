import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/devices/domain/entities/device_measurement.dart';
import 'package:restock/devices/presentation/utils/devices_theme.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_bloc.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_event.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_state.dart';
import 'package:restock/resources/application/custom_supply_facade_service.dart';
import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/widgets/restok_button.dart';

class AssignBatchBottomSheet extends StatefulWidget {
  const AssignBatchBottomSheet({
    super.key,
    required this.customSupplyFacadeService,
  });

  final CustomSupplyFacadeService customSupplyFacadeService;

  @override
  State<AssignBatchBottomSheet> createState() => _AssignBatchBottomSheetState();
}

class _AssignBatchBottomSheetState extends State<AssignBatchBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _unitWeightController = TextEditingController();
  final _tareWeightController = TextEditingController(text: '0');

  List<CustomSupply> _supplies = [];
  bool _loadingSupplies = true;
  String? _selectedSupplyId;
  String _selectedWeightUnit = 'g';
  bool _isSubmitting = false;

  static const _weightUnits = [
    ('g', 'Grams (g)'),
    ('kg', 'Kilograms (kg)'),
    ('l', 'Liters (l)'),
    ('ml', 'Milliliters (ml)'),
    ('unit', 'Units'),
  ];

  @override
  void initState() {
    super.initState();
    _loadSupplies();
  }

  Future<void> _loadSupplies() async {
    try {
      final supplies =
          await widget.customSupplyFacadeService.getCustomSuppliesByBranchId();
      if (mounted) setState(() { _supplies = supplies; _loadingSupplies = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingSupplies = false);
    }
  }

  @override
  void dispose() {
    _unitWeightController.dispose();
    _tareWeightController.dispose();
    super.dispose();
  }

  void _submit(BuildContext ctx) {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSupplyId == null) return;

    setState(() => _isSubmitting = true);
    ctx.read<DeviceDetailBloc>().add(
      BatchAssigned(
        customSupplyId: _selectedSupplyId!,
        measurement: DeviceMeasurement(
          weightUnit: _selectedWeightUnit,
          unitWeight: double.parse(_unitWeightController.text.trim()),
          tareWeight: double.parse(_tareWeightController.text.trim()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceDetailBloc, DeviceDetailState>(
      listener: (context, state) {
        if (!state.isSubmitting && _isSubmitting) {
          if (state.errorMessage != null) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: DevicesTheme.criticalBorder,
              ),
            );
          } else if (state.status == Status.success) {
            Navigator.of(context).pop(true);
          }
        }
      },
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: DevicesTheme.borderGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(
                    DevicesTheme.sidePadding,
                    8,
                    DevicesTheme.sidePadding,
                    16,
                  ),
                  child: Text(
                    'Assign Batch',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: DevicesTheme.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: _loadingSupplies
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: DevicesTheme.greenPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: DevicesTheme.sidePadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Supply'),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                initialValue: _selectedSupplyId,
                                hint: const Text(
                                  'Select a supply',
                                  style: TextStyle(
                                    color: DevicesTheme.textSecondary,
                                  ),
                                ),
                                decoration: _inputDecoration(),
                                items: _supplies
                                    .map(
                                      (s) => DropdownMenuItem(
                                        value: s.customSupplyId,
                                        child: Text(s.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _selectedSupplyId = v),
                                validator: (v) =>
                                    v == null ? 'Select a supply' : null,
                              ),
                              const SizedBox(height: 16),
                              _label('Weight Unit'),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                initialValue: _selectedWeightUnit,
                                decoration: _inputDecoration(),
                                items: _weightUnits
                                    .map(
                                      (u) => DropdownMenuItem(
                                        value: u.$1,
                                        child: Text(u.$2),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) => setState(
                                  () => _selectedWeightUnit = v ?? 'g',
                                ),
                              ),
                              const SizedBox(height: 16),
                              _label('Unit Weight'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _unitWeightController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                decoration: _inputDecoration(
                                  hint: 'e.g. 100',
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Unit weight is required';
                                  }
                                  if (double.tryParse(v.trim()) == null) {
                                    return 'Enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _label('Tare Weight'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _tareWeightController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                decoration: _inputDecoration(hint: '0'),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Tare weight is required';
                                  }
                                  if (double.tryParse(v.trim()) == null) {
                                    return 'Enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    DevicesTheme.sidePadding,
                    0,
                    DevicesTheme.sidePadding,
                    MediaQuery.of(context).viewInsets.bottom +
                        DevicesTheme.sidePadding,
                  ),
                  child: RestockButton(
                    text: 'Save Assignment',
                    isLoading: _isSubmitting,
                    onPressed:
                        (_isSubmitting || _selectedSupplyId == null)
                            ? null
                            : () => _submit(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: DevicesTheme.textPrimary,
        ),
      );

  InputDecoration _inputDecoration({String? hint}) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: DevicesTheme.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
          borderSide: const BorderSide(color: DevicesTheme.borderGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
          borderSide: const BorderSide(color: DevicesTheme.borderGray),
        ),
      );
}
