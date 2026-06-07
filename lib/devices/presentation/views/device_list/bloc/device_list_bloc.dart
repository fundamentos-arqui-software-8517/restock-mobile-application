import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/devices/application/device_facade_service.dart';
import 'package:restock/devices/domain/entities/device.dart';
import 'package:restock/devices/domain/entities/device_status.dart';
import 'package:restock/devices/presentation/views/device_list/bloc/device_list_event.dart';
import 'package:restock/devices/presentation/views/device_list/bloc/device_list_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class DeviceListBloc extends Bloc<DeviceListEvent, DeviceListState> {
  DeviceListBloc({required this.deviceFacadeService})
      : super(const DeviceListState()) {
    on<GetDevices>(_onGetDevices);
    on<DeviceRegistered>(_onDeviceRegistered);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<DeviceStatusChanged>(_onDeviceStatusChanged);
  }

  final DeviceFacadeService deviceFacadeService;

  Future<void> _onGetDevices(
    GetDevices event,
    Emitter<DeviceListState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final devices = await deviceFacadeService.getDevicesByAccountId();
      emit(state.copyWith(status: Status.success, devices: devices));
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: 'Failed to load devices',
        ),
      );
    }
  }

  Future<void> _onDeviceRegistered(
    DeviceRegistered event,
    Emitter<DeviceListState> emit,
  ) async {
    try {
      final device = await deviceFacadeService.registerDevice(
        macAddress: event.macAddress,
        description: event.description,
      );
      emit(
        state.copyWith(
          status: Status.success,
          devices: [...state.devices, device],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: 'Failed to register device',
        ),
      );
    }
  }

  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<DeviceListState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onDeviceStatusChanged(
    DeviceStatusChanged event,
    Emitter<DeviceListState> emit,
  ) {
    final updated = state.devices.map((d) {
      if (d.deviceId != event.deviceId) return d;
      return Device(
        deviceId: d.deviceId,
        accountId: d.accountId,
        macAddress: d.macAddress,
        description: d.description,
        status: DeviceStatus.fromApi(event.status),
        specifications: d.specifications,
        branchId: d.branchId,
        customSupplyId: d.customSupplyId,
        thresholdId: d.thresholdId,
        measurement: d.measurement,
      );
    }).toList();
    emit(state.copyWith(status: Status.success, devices: updated));
  }
}
