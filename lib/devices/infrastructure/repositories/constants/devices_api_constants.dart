/// Constants for the Devices API endpoints.
class DevicesApiConstants {
  // Devices endpoints
  static final String devices = 'devices';
  static String deviceById = 'devices/{deviceId}';
  static String deviceSpecifications = 'devices/{deviceId}/specifications';
  static String deviceConfigBranch = 'devices/{deviceId}/configuration/branch';
  static String deviceConfigBatch = 'devices/{deviceId}/configuration/batch';
  static String deviceConfigThreshold =
      'devices/{deviceId}/configuration/threshold';
  static String deviceConfigMeasurement =
      'devices/{deviceId}/configuration/measurement';
  static String deviceStatus = 'devices/{deviceId}/status';
  static String deviceWithdrawnStock = 'devices/{deviceId}/withdrawn-stock';

  // Device thresholds endpoints
  static final String deviceThresholds = 'device-thresholds';
  static String deviceThresholdById = 'device-thresholds/{thresholdId}';
}
