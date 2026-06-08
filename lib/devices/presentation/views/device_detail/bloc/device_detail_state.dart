import 'package:restock/devices/domain/entities/device.dart';
import 'package:restock/devices/domain/entities/device_threshold.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class DeviceDetailState {
  const DeviceDetailState({
    this.status = Status.initial,
    this.device,
    this.threshold,
    this.errorMessage,
    this.isSubmitting = false,
  });

  final Status status;
  final Device? device;
  final DeviceThreshold? threshold;
  final String? errorMessage;
  final bool isSubmitting;

  DeviceDetailState copyWith({
    Status? status,
    Device? device,
    DeviceThreshold? threshold,
    String? errorMessage,
    bool? isSubmitting,
  }) {
    return DeviceDetailState(
      status: status ?? this.status,
      device: device ?? this.device,
      threshold: threshold ?? this.threshold,
      errorMessage: errorMessage ?? this.errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
