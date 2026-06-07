abstract class DeviceListEvent {
  const DeviceListEvent();
}

class GetDevices extends DeviceListEvent {
  const GetDevices();
}

class DeviceRegistered extends DeviceListEvent {
  const DeviceRegistered({
    required this.macAddress,
    required this.description,
  });

  final String macAddress;
  final String description;
}

class SearchQueryChanged extends DeviceListEvent {
  const SearchQueryChanged(this.query);

  final String query;
}

class DeviceStatusChanged extends DeviceListEvent {
  const DeviceStatusChanged({
    required this.deviceId,
    required this.status,
  });

  final String deviceId;
  final String status;
}
