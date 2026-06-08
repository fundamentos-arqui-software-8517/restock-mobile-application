import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/devices/application/device_facade_service.dart';
import 'package:restock/devices/domain/entities/batch.dart';
import 'package:restock/devices/domain/entities/device_measurement.dart';
import 'package:restock/devices/presentation/utils/devices_theme.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_bloc.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_event.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/widgets/restok_button.dart';

class AssignBatchBottomSheet extends StatefulWidget {
  const AssignBatchBottomSheet({
    super.key,
    required this.deviceFacadeService,
  });

  final DeviceFacadeService deviceFacadeService;

  @override
  State<AssignBatchBottomSheet> createState() => _AssignBatchBottomSheetState();
}

class _AssignBatchBottomSheetState extends State<AssignBatchBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _unitWeightController = TextEditingController();
  final _tareWeightController = TextEditingController(text: '0');

  List<Batch> _batches = [];
  bool _loadingBatches = true;
  Batch? _selectedBatch;
  // (abbreviation, fullName, displayLabel)
  static const _weightUnits = [
    ('g', 'grams', 'Grams (g)'),
    ('kg', 'kilograms', 'Kilograms (kg)'),
    ('l', 'liters', 'Liters (l)'),
    ('ml', 'milliliters', 'Milliliters (ml)'),
    ('unit', 'units', 'Units'),
  ];

  String _selectedWeightUnitAbbreviation = 'g';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadBatches();
  }

  Future<void> _loadBatches() async {
    try {
      final batches = await widget.deviceFacadeService.getBatchesForAssignment();
      if (mounted) {
        setState(() {
          _batches = batches;
          _loadingBatches = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingBatches = false);
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
    if (_selectedBatch == null) return;

    setState(() => _isSubmitting = true);
    final unit = _weightUnits.firstWhere(
      (u) => u.$1 == _selectedWeightUnitAbbreviation,
      orElse: () => _weightUnits.first,
    );
    final batch = _selectedBatch!;
    ctx.read<DeviceDetailBloc>().add(
      BatchAssigned(
        batchId: batch.id,
        customSupplyId: batch.customSupplyId,
        minStock: batch.minimumStock ?? 0.0,
        maxStock: batch.maximumStock ?? batch.currentStock,
        measurement: DeviceMeasurement(
          netWeight: double.parse(_unitWeightController.text.trim()),
          tareWeight: double.parse(_tareWeightController.text.trim()),
          weightUnitName: unit.$2,
          weightUnitAbbreviation: unit.$1,
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
                  child: _loadingBatches
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
                              _label('Batch'),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<Batch>(
                                initialValue: _selectedBatch,
                                hint: const Text(
                                  'Select a batch',
                                  style: TextStyle(
                                    color: DevicesTheme.textSecondary,
                                  ),
                                ),
                                decoration: _inputDecoration(),
                                items: _batches
                                    .map(
                                      (b) => DropdownMenuItem(
                                        value: b,
                                        child: Text(b.displayLabel),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _selectedBatch = v),
                                validator: (v) =>
                                    v == null ? 'Select a batch' : null,
                              ),
                              const SizedBox(height: 16),
                              _label('Weight Unit'),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                initialValue: _selectedWeightUnitAbbreviation,
                                decoration: _inputDecoration(),
                                items: _weightUnits
                                    .map(
                                      (u) => DropdownMenuItem(
                                        value: u.$1,
                                        child: Text(u.$3),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) => setState(
                                  () => _selectedWeightUnitAbbreviation =
                                      v ?? 'g',
                                ),
                              ),
                              const SizedBox(height: 16),
                              _label('Net Weight'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _unitWeightController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                decoration: _inputDecoration(hint: 'e.g. 100'),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Net weight is required';
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
                    onPressed: (_isSubmitting || _selectedBatch == null)
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
