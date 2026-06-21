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

class _EditThresholdsBottomSheetState extends State<EditThresholdsBottomSheet> {
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
      text: e != null ? e.anomalyThreshold.toString() : '1',
    );
    _minTemp = TextEditingController(text: e?.minTemperature?.toString() ?? '');
    _maxTemp = TextEditingController(text: e?.maxTemperature?.toString() ?? '');
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
        anomalyThreshold: double.tryParse(_anomaly.text.trim()) ?? 1,
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
      child: Scaffold(
        backgroundColor: DevicesTheme.background,
        appBar: AppBar(
          backgroundColor: DevicesTheme.headerDark,
          foregroundColor: Colors.white,
          title: const Text(
            'Set Thresholds',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: ColoredBox(
            color: Colors.white,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(
                      DevicesTheme.sidePadding,
                      20,
                      DevicesTheme.sidePadding,
                      16,
                    ),
                    child: _SheetHeader(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DevicesTheme.sidePadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(
                            height: 1,
                            color: DevicesTheme.borderGray,
                          ),
                          const SizedBox(height: 16),
                          const _SectionTitle(
                            icon: Icons.inventory_2_outlined,
                            title: 'Stock limits',
                          ),
                          const SizedBox(height: 14),
                          _stockFields(context),
                          const SizedBox(height: 24),
                          const _SectionTitle(
                            icon: Icons.thermostat_outlined,
                            title: 'Environmental limits',
                          ),
                          const SizedBox(height: 12),
                          _environmentCards(context),
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
                      DevicesTheme.sidePadding,
                    ),
                    child: RestockButton(
                      text: 'Complete setup',
                      isLoading: _isSubmitting,
                      onPressed: _isSubmitting ? null : () => _submit(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stockFields(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 620;
    if (wide) {
      return Row(
        children: [
          Expanded(
            child: _limitField(
              controller: _minStock,
              label: 'MINIMUM STOCK ALERT',
              suffix: 'units',
              required: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _limitField(
              controller: _maxStock,
              label: 'MAXIMUM CAPACITY',
              suffix: 'units',
              required: true,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _limitField(
          controller: _minStock,
          label: 'MINIMUM STOCK ALERT',
          suffix: 'units',
          required: true,
        ),
        const SizedBox(height: 12),
        _limitField(
          controller: _maxStock,
          label: 'MAXIMUM CAPACITY',
          suffix: 'units',
          required: true,
        ),
      ],
    );
  }

  Widget _environmentCards(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 620;
    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _RangeCard(
              title: 'Temperature',
              subtitle: 'Allowed sensor range in C',
              minController: _minTemp,
              maxController: _maxTemp,
              validator: _optionalNumberValidator,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _RangeCard(
              title: 'Humidity',
              subtitle: 'Allowed relative humidity',
              minController: _minHumidity,
              maxController: _maxHumidity,
              validator: _optionalNumberValidator,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _RangeCard(
          title: 'Temperature',
          subtitle: 'Allowed sensor range in C',
          minController: _minTemp,
          maxController: _maxTemp,
          validator: _optionalNumberValidator,
        ),
        const SizedBox(height: 12),
        _RangeCard(
          title: 'Humidity',
          subtitle: 'Allowed relative humidity',
          minController: _minHumidity,
          maxController: _maxHumidity,
          validator: _optionalNumberValidator,
        ),
      ],
    );
  }

  String? _optionalNumberValidator(String? v) {
    if (v != null && v.trim().isNotEmpty && double.tryParse(v.trim()) == null) {
      return 'Enter a valid number';
    }
    return null;
  }

  Widget _limitField({
    required TextEditingController controller,
    required String label,
    required bool required,
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: DevicesTheme.textSecondary,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: _fieldDecoration(suffix: suffix),
          validator: (v) {
            if (required && (v == null || v.trim().isEmpty)) {
              return '$label is required';
            }
            return _optionalNumberValidator(v);
          },
        ),
      ],
    );
  }

  static InputDecoration _fieldDecoration({String? hint, String? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: DevicesTheme.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      suffixText: suffix,
      suffixStyle: const TextStyle(
        color: DevicesTheme.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
        borderSide: const BorderSide(color: DevicesTheme.borderGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
        borderSide: const BorderSide(color: DevicesTheme.borderGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
        borderSide: const BorderSide(color: DevicesTheme.greenPrimary),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFE2F8EC),
            shape: BoxShape.circle,
          ),
          child: const Text(
            '4',
            style: TextStyle(
              color: DevicesTheme.greenPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alert thresholds',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: DevicesTheme.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Define stock and environmental limits for automatic monitoring.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: DevicesTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: DevicesTheme.greenPrimary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: DevicesTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _RangeCard extends StatelessWidget {
  const _RangeCard({
    required this.title,
    required this.subtitle,
    required this.minController,
    required this.maxController,
    required this.validator,
  });

  final String title;
  final String subtitle;
  final TextEditingController minController;
  final TextEditingController maxController;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFCFD),
        borderRadius: BorderRadius.circular(DevicesTheme.radiusSm),
        border: Border.all(color: DevicesTheme.borderGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: DevicesTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: DevicesTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: minController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: _EditThresholdsBottomSheetState._fieldDecoration(
                    hint: 'Min',
                  ),
                  validator: validator,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'TO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: DevicesTheme.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: maxController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: _EditThresholdsBottomSheetState._fieldDecoration(
                    hint: 'Max',
                  ),
                  validator: validator,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
