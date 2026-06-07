import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/devices/application/device_facade_service.dart';
import 'package:restock/devices/application/device_threshold_facade_service.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_event.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class DeviceDetailBloc extends Bloc<DeviceDetailEvent, DeviceDetailState> {
  DeviceDetailBloc({
    required this.deviceFacadeService,
    required this.deviceThresholdFacadeService,
  }) : super(const DeviceDetailState()) {
    on<DeviceDetailFetched>(_onFetched);
    on<BatchAssigned>(_onBatchAssigned);
    on<DeviceUnlinked>(_onDeviceUnlinked);
    on<ThresholdsSaved>(_onThresholdsSaved);
  }

  final DeviceFacadeService deviceFacadeService;
  final DeviceThresholdFacadeService deviceThresholdFacadeService;

  Future<void> _onFetched(
    DeviceDetailFetched event,
    Emitter<DeviceDetailState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final device = await deviceFacadeService.getDeviceById(event.deviceId);
      var newState = state.copyWith(status: Status.success, device: device);
      if (device.supplyThresholdId != null) {
        final threshold = await deviceThresholdFacadeService
            .getThresholdById(device.supplyThresholdId!);
        newState = newState.copyWith(threshold: threshold);
      }
      emit(newState);
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: 'Failed to load device',
        ),
      );
    }
  }

  Future<void> _onBatchAssigned(
    BatchAssigned event,
    Emitter<DeviceDetailState> emit,
  ) async {
    final deviceId = state.device?.deviceId;
    if (deviceId == null) return;

    emit(state.copyWith(isSubmitting: true));
    try {
      final updated = await deviceFacadeService.completeOnboarding(
        deviceId: deviceId,
        batchId: event.batchId,
        customSupplyId: event.customSupplyId,
        minStock: event.minStock,
        maxStock: event.maxStock,
        measurement: event.measurement,
      );
      var newState = state.copyWith(
        status: Status.success,
        device: updated,
        isSubmitting: false,
      );
      if (updated.supplyThresholdId != null) {
        try {
          final threshold = await deviceThresholdFacadeService
              .getThresholdById(updated.supplyThresholdId!);
          newState = newState.copyWith(threshold: threshold);
        } catch (_) {}
      }
      emit(newState);
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeviceUnlinked(
    DeviceUnlinked event,
    Emitter<DeviceDetailState> emit,
  ) async {
    final device = state.device;
    if (device == null) return;

    emit(state.copyWith(isSubmitting: true));
    try {
      await deviceFacadeService.unlinkDevice(device.deviceId);
      final updated =
          await deviceFacadeService.getDeviceById(device.deviceId);
      emit(
        state.copyWith(
          status: Status.success,
          device: updated,
          isSubmitting: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onThresholdsSaved(
    ThresholdsSaved event,
    Emitter<DeviceDetailState> emit,
  ) async {
    final device = state.device;
    if (device == null) return;

    emit(state.copyWith(isSubmitting: true));
    try {
      final threshold = await deviceThresholdFacadeService.createAndAssign(
        deviceId: device.deviceId,
        customSupplyId: state.threshold?.customSupplyId ?? '',
        minStock: event.minStock,
        maxStock: event.maxStock,
        anomalyThreshold: event.anomalyThreshold,
        minTemperature: event.minTemperature,
        maxTemperature: event.maxTemperature,
        minHumidity: event.minHumidity,
        maxHumidity: event.maxHumidity,
      );
      final updated =
          await deviceFacadeService.getDeviceById(device.deviceId);
      emit(
        state.copyWith(
          status: Status.success,
          device: updated,
          threshold: threshold,
          isSubmitting: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
