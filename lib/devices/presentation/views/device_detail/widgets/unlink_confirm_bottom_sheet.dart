import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/devices/presentation/utils/devices_theme.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_bloc.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_event.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class UnlinkConfirmBottomSheet extends StatefulWidget {
  const UnlinkConfirmBottomSheet({super.key, required this.deviceId});

  final String deviceId;

  @override
  State<UnlinkConfirmBottomSheet> createState() =>
      _UnlinkConfirmBottomSheetState();
}

class _UnlinkConfirmBottomSheetState extends State<UnlinkConfirmBottomSheet> {
  final _confirmController = TextEditingController();
  bool _canUnlink = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _confirmController.addListener(() {
      final match = _confirmController.text.trim() == widget.deviceId;
      if (match != _canUnlink) setState(() => _canUnlink = match);
    });
  }

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
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
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Red warning header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                decoration: const BoxDecoration(
                  color: DevicesTheme.criticalBg,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: DevicesTheme.criticalBorder
                              .withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: DevicesTheme.criticalBorder,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Unlink Device',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: DevicesTheme.criticalBorder,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This will set the device to INACTIVE. All monitoring will stop immediately.',
                      style: TextStyle(
                        fontSize: 13,
                        color: DevicesTheme.criticalText,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(DevicesTheme.sidePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Device ID',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: DevicesTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: DevicesTheme.background,
                          borderRadius:
                              BorderRadius.circular(DevicesTheme.radiusSm),
                          border:
                              Border.all(color: DevicesTheme.borderGray),
                        ),
                        child: Text(
                          widget.deviceId,
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'monospace',
                            color: DevicesTheme.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Write the Device ID to confirm',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: DevicesTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _confirmController,
                        decoration: InputDecoration(
                          hintText: 'Paste or type the Device ID',
                          hintStyle: const TextStyle(
                            color: DevicesTheme.textSecondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(DevicesTheme.radiusSm),
                            borderSide: BorderSide(
                              color: _canUnlink
                                  ? DevicesTheme.criticalBorder
                                  : DevicesTheme.borderGray,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(DevicesTheme.radiusSm),
                            borderSide: BorderSide(
                              color: _canUnlink
                                  ? DevicesTheme.criticalBorder
                                  : DevicesTheme.borderGray,
                            ),
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
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: (_canUnlink && !_isSubmitting)
                        ? () {
                            setState(() => _isSubmitting = true);
                            context
                                .read<DeviceDetailBloc>()
                                .add(const DeviceUnlinked());
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DevicesTheme.criticalBorder,
                      disabledBackgroundColor:
                          DevicesTheme.criticalBorder.withValues(alpha: 0.4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(DevicesTheme.radiusSm),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Unlink Device',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
