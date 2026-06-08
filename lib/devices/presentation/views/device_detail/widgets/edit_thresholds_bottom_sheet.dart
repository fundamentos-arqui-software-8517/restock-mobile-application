import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/devices/domain/entities/device_threshold.dart';
import 'package:restock/devices/presentation/utils/devices_theme.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_bloc.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_event.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/widgets/restok_button.dart';

class EditThresholdsBottomSheet extends StatefulWidget {
  const EditThresholdsBottomSheet({super.key, this.existing});

  final DeviceThreshold? existing;

  @override
  State<EditThresholdsBottomSheet> createState() =>
      _EditThresholdsBottomSheetState();
}

class _EditThresholdsBottomSheetState
    extends State<EditThresholdsBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _minStock;
  late final TextEditingController _maxStock;
  late final TextEditingController _anomaly;
  late final TextEditingController _minTemp;
  late final TextEditingController _maxTemp;
  late final TextEditingController _minHumidity;
  late final TextEditingController _maxHumidity;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _minStock = TextEditingController(
      text: e != null ? e.minStock.toString() : '',
    );
    _maxStock = TextEditingController(
      text: e != null ? e.maxStock.toString() : '',
    );
    _anomaly = TextEditingController(
      text: e != null ? e.anomalyThreshold.toString() : '',
    );
    _minTemp = TextEditingController(
      text: e?.minTemperature?.toString() ?? '',
    );
    _maxTemp = TextEditingController(
      text: e?.maxTemperature?.toString() ?? '',
    );
    _minHumidity = TextEditingController(
      text: e?.minHumidity?.toString() ?? '',
    );
    _maxHumidity = TextEditingController(
      text: e?.maxHumidity?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _minStock.dispose();
    _maxStock.dispose();
    _anomaly.dispose();
    _minTemp.dispose();
    _maxTemp.dispose();
    _minHumidity.dispose();
    _maxHumidity.dispose();
    super.dispose();
  }

  void _submit(BuildContext ctx) {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    ctx.read<DeviceDetailBloc>().add(
      ThresholdsSaved(
        minStock: double.parse(_minStock.text.trim()),
        maxStock: double.parse(_maxStock.text.trim()),
        anomalyThreshold: double.parse(_anomaly.text.trim()),
        minTemperature: _optDouble(_minTemp.text),
        maxTemperature: _optDouble(_maxTemp.text),
        minHumidity: _optDouble(_minHumidity.text),
        maxHumidity: _optDouble(_maxHumidity.text),
      ),
    );
  }

  double? _optDouble(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
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
            Navigator.of(context).pop();
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
                    'Alert Thresholds',
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
                        _sectionLabel('Stock Limits'),
                        const SizedBox(height: 8),
                        _field(
                          controller: _minStock,
                          label: 'Min Stock',
                          required: true,
                        ),
                        const SizedBox(height: 12),
                        _field(
                          controller: _maxStock,
                          label: 'Max Stock',
                          required: true,
                        ),
                        const SizedBox(height: 12),
                        _field(
                          controller: _anomaly,
                          label: 'Anomaly Threshold',
                          required: true,
                        ),
                        const SizedBox(height: 20),
                        _sectionLabel('Temperature (optional)'),
                        const SizedBox(height: 8),
                        _field(
                          controller: _minTemp,
                          label: 'Min Temperature (°C)',
                          required: false,
                        ),
                        const SizedBox(height: 12),
                        _field(
                          controller: _maxTemp,
                          label: 'Max Temperature (°C)',
                          required: false,
                        ),
                        const SizedBox(height: 20),
                        _sectionLabel('Humidity (optional)'),
                        const SizedBox(height: 8),
                        _field(
                          controller: _minHumidity,
                          label: 'Min Humidity (%)',
                          required: false,
                        ),
                        const SizedBox(height: 12),
                        _field(
                          controller: _maxHumidity,
                          label: 'Max Humidity (%)',
                          required: false,
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
                    text: 'Save Thresholds',
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

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: DevicesTheme.textSecondary,
      letterSpacing: 0.5,
    ),
  );

  Widget _field({
    required TextEditingController controller,
    required String label,
    required bool required,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: DevicesTheme.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
          borderSide: const BorderSide(color: DevicesTheme.borderGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
          borderSide: const BorderSide(color: DevicesTheme.borderGray),
        ),
      ),
      validator: (v) {
        if (required && (v == null || v.trim().isEmpty)) {
          return '$label is required';
        }
        if (v != null && v.trim().isNotEmpty &&
            double.tryParse(v.trim()) == null) {
          return 'Enter a valid number';
        }
        return null;
      },
    );
  }
}
