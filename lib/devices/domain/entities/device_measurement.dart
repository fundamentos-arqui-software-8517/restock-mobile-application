class DeviceMeasurement {
  const DeviceMeasurement({
    required this.weightUnit,
    required this.unitWeight,
    required this.tareWeight,
    this.calibrationDate,
  });

  final String weightUnit;
  final double unitWeight;
  final double tareWeight;
  final DateTime? calibrationDate;

  DeviceMeasurement copyWith({
    String? weightUnit,
    double? unitWeight,
    double? tareWeight,
    DateTime? calibrationDate,
  }) {
    return DeviceMeasurement(
      weightUnit: weightUnit ?? this.weightUnit,
      unitWeight: unitWeight ?? this.unitWeight,
      tareWeight: tareWeight ?? this.tareWeight,
      calibrationDate: calibrationDate ?? this.calibrationDate,
    );
  }
}
