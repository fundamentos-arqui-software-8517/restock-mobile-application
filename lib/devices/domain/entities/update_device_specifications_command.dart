import 'device_specifications.dart';

class UpdateDeviceSpecificationsCommand {
  const UpdateDeviceSpecificationsCommand({
    required this.deviceId,
    required this.specifications,
  });

  final String deviceId;
  final DeviceSpecifications specifications;
}
