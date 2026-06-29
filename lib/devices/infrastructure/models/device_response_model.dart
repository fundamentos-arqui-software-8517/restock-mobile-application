import 'package:restock/devices/domain/entities/device.dart';
import 'package:restock/devices/domain/entities/device_measurement.dart';
import 'package:restock/devices/domain/entities/device_specifications.dart';
import 'package:restock/devices/domain/entities/device_status.dart';

class DeviceResponseModel {
  const DeviceResponseModel({
    required this.deviceId,
    required this.accountId,
    required this.macAddress,
    required this.description,
    required this.status,
    this.specifications,
    this.branchId,
    this.assignedBatchId,
    this.supplyThresholdId,
    this.measurement,
  });

  final String deviceId;
  final String accountId;
  final String macAddress;
  final String description;
  final String status;
  final DeviceSpecifications? specifications;
  final String? branchId;
  final String? assignedBatchId;
  final String? supplyThresholdId;
  final DeviceMeasurement? measurement;

  factory DeviceResponseModel.fromJson(Map<String, dynamic> json) {
    String value(String key, {String fallback = ''}) =>
        json[key]?.toString() ?? fallback;

    // Back returns specs flat (manufacturer, model, firmwareVersion)
    DeviceSpecifications? parseSpecifications() {
      final manufacturer = json['manufacturer']?.toString();
      final model = json['model']?.toString();
      final firmware = json['firmwareVersion']?.toString();
      if (manufacturer == null && model == null && firmware == null) {
        // Fallback: try nested 'specifications' object (older response shape)
        final specs = json['specifications'];
        if (specs is Map<String, dynamic>) {
          return DeviceSpecifications(
            manufacturer: specs['manufacturer']?.toString() ?? '',
            model: specs['model']?.toString() ?? '',
            firmwareVersion: specs['firmwareVersion']?.toString() ?? '',
          );
        }
        return null;
      }
      return DeviceSpecifications(
        manufacturer: manufacturer ?? '',
        model: model ?? '',
        firmwareVersion: firmware ?? '',
      );
    }

    // Back returns measurement fields flat (not nested)
    DeviceMeasurement? parseMeasurement() {
      final measurement =
          _asMap(json['measurement']) ??
          _asMap(json['weightMeasurement']) ??
          json;
      final netWeight = _toDouble(measurement['netWeight']);
      if (netWeight == null) return null;
      return DeviceMeasurement(
        netWeight: netWeight,
        tareWeight: _toDouble(measurement['tareWeight']) ?? 0.0,
        grossWeight: _toDouble(measurement['grossWeight']),
        // response uses 'weightUnit'; request uses 'weightUnitName'
        weightUnitName:
            measurement['weightUnitName']?.toString() ??
            measurement['weightUnit']?.toString() ??
            '',
        weightUnitAbbreviation:
            measurement['weightUnitAbbreviation']?.toString() ?? '',
        calibrationDate: measurement['calibrationDate']?.toString(),
      );
    }

    return DeviceResponseModel(
      deviceId: value('id', fallback: value('deviceId')),
      accountId: value('accountId'),
      macAddress: value('macAddress'),
      description: value('description'),
      status: value('status', fallback: 'REGISTERED'),
      specifications: parseSpecifications(),
      branchId: json['branchId']?.toString(),
      assignedBatchId: json['assignedBatchId']?.toString(),
      supplyThresholdId: json['supplyThresholdId']?.toString(),
      measurement: parseMeasurement(),
    );
  }

  static Map<String, dynamic>? _asMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static double? _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    return null;
  }

  Device toDomain() {
    return Device(
      deviceId: deviceId,
      accountId: accountId,
      macAddress: macAddress,
      description: description,
      status: DeviceStatus.fromApi(status),
      specifications: specifications,
      branchId: branchId,
      assignedBatchId: assignedBatchId,
      supplyThresholdId: supplyThresholdId,
      measurement: measurement,
    );
  }
}
