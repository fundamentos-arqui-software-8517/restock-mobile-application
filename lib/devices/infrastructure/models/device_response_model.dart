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
    this.customSupplyId,
    this.thresholdId,
    this.measurement,
  });

  final String deviceId;
  final String accountId;
  final String macAddress;
  final String description;
  final String status;
  final DeviceSpecifications? specifications;
  final String? branchId;
  final String? customSupplyId;
  final String? thresholdId;
  final DeviceMeasurement? measurement;

  factory DeviceResponseModel.fromJson(Map<String, dynamic> json) {
    String value(String key, {String fallback = ''}) =>
        json[key]?.toString() ?? fallback;

    DeviceSpecifications? parseSpecifications() {
      final specs = json['specifications'];
      if (specs is! Map<String, dynamic>) return null;
      return DeviceSpecifications(
        manufacturer: specs['manufacturer']?.toString() ?? '',
        model: specs['model']?.toString() ?? '',
        firmwareVersion: specs['firmwareVersion']?.toString() ?? '',
      );
    }

    DeviceMeasurement? parseMeasurement() {
      final m = json['measurement'];
      if (m is! Map<String, dynamic>) return null;
      return DeviceMeasurement(
        weightUnit: m['weightUnit']?.toString() ?? 'g',
        unitWeight: (m['unitWeight'] as num?)?.toDouble() ?? 0.0,
        tareWeight: (m['tareWeight'] as num?)?.toDouble() ?? 0.0,
        calibrationDate: m['calibrationDate'] != null
            ? DateTime.tryParse(m['calibrationDate'].toString())
            : null,
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
      customSupplyId: json['customSupplyId']?.toString(),
      thresholdId: json['thresholdId']?.toString(),
      measurement: parseMeasurement(),
    );
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
      customSupplyId: customSupplyId,
      thresholdId: thresholdId,
      measurement: measurement,
    );
  }
}
