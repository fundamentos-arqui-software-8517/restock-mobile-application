import '../../domain/entities/device_status.dart';

enum DeviceHealth { healthy, warm, critical, offline }

class DeviceHealthMock {
  // TODO(EP-13/telemetry): reemplazar por el cálculo real basado en las últimas
  // readings del device (temperatura, humedad, conectividad). Por ahora es un
  // valor estable por deviceId para que la UI no parpadee entre renders.
  static DeviceHealth of(String deviceId, DeviceStatus status) {
    if (status == DeviceStatus.inactive) return DeviceHealth.offline;
    final hash = deviceId.hashCode.abs() % 4;
    switch (hash) {
      case 0:
      case 1:
        return DeviceHealth.healthy;
      case 2:
        return DeviceHealth.warm;
      default:
        return DeviceHealth.critical;
    }
  }

  static String label(DeviceHealth h) => switch (h) {
        DeviceHealth.healthy => 'HEALTHY',
        DeviceHealth.warm => 'WARM',
        DeviceHealth.critical => 'CRITICAL',
        DeviceHealth.offline => 'OFFLINE',
      };
}
