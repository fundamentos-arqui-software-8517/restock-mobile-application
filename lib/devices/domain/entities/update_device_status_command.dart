import 'device_status.dart';

class UpdateDeviceStatusCommand {
  const UpdateDeviceStatusCommand({
    required this.deviceId,
    required this.status,
  });

  final String deviceId;
  final DeviceStatus status;
}
