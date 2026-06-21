import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/devices/domain/entities/device.dart';
import 'package:restock/devices/domain/entities/device_measurement.dart';
import 'package:restock/devices/presentation/utils/devices_theme.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_bloc.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_event.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/widgets/restok_button.dart';

class WeightCalibrationCard extends StatelessWidget {
  const WeightCalibrationCard({
    super.key,
    required this.device,
    required this.onCalibrate,
  });

  final Device device;
  final VoidCallback onCalibrate;

  @override
  Widget build(BuildContext context) {
    final measurement = device.measurement;
    final hasBatch = device.hasBatch;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: DevicesTheme.sidePadding,
        vertical: 6,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DevicesTheme.cardBackground,
        borderRadius: BorderRadius.circular(DevicesTheme.radiusMd),
        border: Border.all(color: DevicesTheme.borderGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: DevicesTheme.greenAccent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '5',
                  style: TextStyle(
                    color: DevicesTheme.greenPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weight calibration',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: DevicesTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Define how sensor weight converts into stock units.',
                      style: TextStyle(
                        fontSize: 12,
                        color: DevicesTheme.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (measurement == null)
            Text(
              hasBatch
                  ? 'No calibration has been saved for this device yet.'
                  : 'Assign a batch before calibrating this device.',
              style: const TextStyle(
                fontSize: 13,
                color: DevicesTheme.textSecondary,
                height: 1.4,
              ),
            )
          else ...[
            _InfoRow(
              label: 'Unit weight',
              value:
                  '${measurement.netWeight} ${measurement.weightUnitAbbreviation}',
            ),
            _InfoRow(
              label: 'Tare weight',
              value:
                  '${measurement.tareWeight} ${measurement.weightUnitAbbreviation}',
            ),
            if (measurement.grossWeight != null)
              _InfoRow(
                label: 'Gross weight',
                value:
                    '${measurement.grossWeight} ${measurement.weightUnitAbbreviation}',
              ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: hasBatch ? onCalibrate : null,
              icon: const Icon(Icons.hourglass_bottom_rounded, size: 18),
              label: Text(
                measurement == null ? 'Calibrate device' : 'Recalibrate',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: DevicesTheme.greenPrimary,
                side: const BorderSide(color: DevicesTheme.greenPrimary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeightCalibrationBottomSheet extends StatefulWidget {
  const WeightCalibrationBottomSheet({super.key, this.initialMeasurement});

  final DeviceMeasurement? initialMeasurement;

  @override
  State<WeightCalibrationBottomSheet> createState() =>
      _WeightCalibrationBottomSheetState();
}

class _WeightCalibrationBottomSheetState
    extends State<WeightCalibrationBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _unitWeightController;
  late final TextEditingController _tareWeightController;

  static const _weightUnits = [
    ('g', 'grams', 'Grams (g)'),
    ('kg', 'kilograms', 'Kilograms (kg)'),
    ('l', 'liters', 'Liters (l)'),
    ('ml', 'milliliters', 'Milliliters (ml)'),
    ('unit', 'units', 'Units'),
  ];

  late String _selectedWeightUnitAbbreviation;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final measurement = widget.initialMeasurement;
    _unitWeightController = TextEditingController(
      text: measurement?.netWeight.toString() ?? '',
    );
    _tareWeightController = TextEditingController(
      text: measurement?.tareWeight.toString() ?? '0',
    );
    _selectedWeightUnitAbbreviation =
        measurement?.weightUnitAbbreviation.isNotEmpty == true
        ? measurement!.weightUnitAbbreviation
        : 'kg';
  }

  @override
  void dispose() {
    _unitWeightController.dispose();
    _tareWeightController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final unit = _weightUnits.firstWhere(
      (u) => u.$1 == _selectedWeightUnitAbbreviation,
      orElse: () => _weightUnits.first,
    );

    setState(() => _isSubmitting = true);
    context.read<DeviceDetailBloc>().add(
      DeviceCalibrated(
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
        initialChildSize: 0.72,
        minChildSize: 0.5,
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
                    'Weight calibration',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: DevicesTheme.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: DevicesTheme.sidePadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            () => _selectedWeightUnitAbbreviation = v ?? 'kg',
                          ),
                        ),
                        const SizedBox(height: 16),
                        _label('Unit Weight'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _unitWeightController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: _inputDecoration(
                            hint: 'e.g. 100',
                            suffix: _selectedWeightUnitAbbreviation,
                          ),
                          validator: _requiredNumber,
                        ),
                        const SizedBox(height: 16),
                        _label('Tare Weight'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _tareWeightController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: _inputDecoration(
                            hint: '0',
                            suffix: _selectedWeightUnitAbbreviation,
                          ),
                          validator: _requiredNumber,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E1),
                            borderRadius: BorderRadius.circular(
                              DevicesTheme.radiusSm,
                            ),
                            border: Border.all(color: const Color(0xFFFFD54F)),
                          ),
                          child: const Text(
                            'Empty the physical scale before applying tare. The current weight becomes the zero reference point.',
                            style: TextStyle(
                              color: Color(0xFF9A5B00),
                              fontSize: 12,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
                    text: 'Calibrate device',
                    isLoading: _isSubmitting,
                    onPressed: _isSubmitting ? null : () => _submit(context),
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

  String? _requiredNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    if (double.tryParse(value.trim()) == null) return 'Enter a valid number';
    return null;
  }

  InputDecoration _inputDecoration({String? hint, String? suffix}) =>
      InputDecoration(
        hintText: hint,
        suffixText: suffix,
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 13,
              color: DevicesTheme.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: DevicesTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
