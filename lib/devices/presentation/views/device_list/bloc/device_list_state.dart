import 'package:restock/devices/domain/entities/device.dart';
import 'package:restock/devices/domain/entities/device_status.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class DeviceListState {
  const DeviceListState({
    this.status = Status.initial,
    this.devices = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  final Status status;
  final List<Device> devices;
  final String searchQuery;
  final String? errorMessage;

  int get totalCount => devices.length;

  int get configuredOrActiveCount => devices
      .where(
        (d) =>
            d.status == DeviceStatus.configured ||
            d.status == DeviceStatus.active,
      )
      .length;

  int get pendingSetupCount =>
      devices.where((d) => d.status == DeviceStatus.registered).length;

  int get inactiveCount =>
      devices.where((d) => d.status == DeviceStatus.inactive).length;

  List<Device> get filteredDevices {
    if (searchQuery.isEmpty) return devices;
    final q = searchQuery.toLowerCase();
    return devices
        .where(
          (d) =>
              d.macAddress.toLowerCase().contains(q) ||
              d.description.toLowerCase().contains(q),
        )
        .toList();
  }

  DeviceListState copyWith({
    Status? status,
    List<Device>? devices,
    String? searchQuery,
    String? errorMessage,
  }) {
    return DeviceListState(
      status: status ?? this.status,
      devices: devices ?? this.devices,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
