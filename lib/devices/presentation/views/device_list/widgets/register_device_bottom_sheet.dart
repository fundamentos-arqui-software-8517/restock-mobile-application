import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/devices/presentation/utils/devices_theme.dart';
import 'package:restock/devices/presentation/views/device_list/bloc/device_list_bloc.dart';
import 'package:restock/devices/presentation/views/device_list/bloc/device_list_event.dart';
import 'package:restock/devices/presentation/views/device_list/bloc/device_list_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/widgets/restok_button.dart';

class RegisterDeviceBottomSheet extends StatefulWidget {
  const RegisterDeviceBottomSheet({super.key});

  @override
  State<RegisterDeviceBottomSheet> createState() =>
      _RegisterDeviceBottomSheetState();
}

class _RegisterDeviceBottomSheetState
    extends State<RegisterDeviceBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _macController = TextEditingController();
  final _aliasController = TextEditingController();
  bool _isSubmitting = false;

  static final _macRegex = RegExp(
    r'^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$',
  );

  @override
  void dispose() {
    _macController.dispose();
    _aliasController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext ctx) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    ctx.read<DeviceListBloc>().add(
      DeviceRegistered(
        macAddress: _macController.text.trim().toUpperCase(),
        description: _aliasController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceListBloc, DeviceListState>(
      listener: (context, state) {
        if (state.status == Status.success && _isSubmitting) {
          Navigator.of(context).pop(true);
        } else if (state.status == Status.failure && _isSubmitting) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Error registering device'),
              backgroundColor: DevicesTheme.criticalBorder,
            ),
          );
        }
      },
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    DevicesTheme.sidePadding,
                    8,
                    DevicesTheme.sidePadding,
                    16,
                  ),
                  child: const Text(
                    'Register Device',
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
                        const Text(
                          'MAC Address',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: DevicesTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _macController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            hintText: 'E4:5F:01:A2:99:BC',
                            hintStyle: const TextStyle(
                              color: DevicesTheme.textSecondary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                DevicesTheme.radiusSm,
                              ),
                              borderSide: const BorderSide(
                                color: DevicesTheme.borderGray,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                DevicesTheme.radiusSm,
                              ),
                              borderSide: const BorderSide(
                                color: DevicesTheme.borderGray,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'MAC address is required';
                            }
                            if (!_macRegex.hasMatch(v.trim())) {
                              return 'Invalid MAC format (e.g. E4:5F:01:A2:99:BC)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Device Alias',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: DevicesTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _aliasController,
                          decoration: InputDecoration(
                            hintText: 'e.g. SE-01, balanza',
                            hintStyle: const TextStyle(
                              color: DevicesTheme.textSecondary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                DevicesTheme.radiusSm,
                              ),
                              borderSide: const BorderSide(
                                color: DevicesTheme.borderGray,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                DevicesTheme.radiusSm,
                              ),
                              borderSide: const BorderSide(
                                color: DevicesTheme.borderGray,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Alias is required';
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
                    text: 'Register Device',
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
}
