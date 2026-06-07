class DeviceMeasurement {
  const DeviceMeasurement({
    required this.netWeight,
    required this.tareWeight,
    required this.weightUnitName,
    required this.weightUnitAbbreviation,
    this.grossWeight,
    this.calibrationDate,
  });

  final double netWeight;
  final double tareWeight;
  final double? grossWeight;
  final String weightUnitName;
  final String weightUnitAbbreviation;
  final String? calibrationDate; // "YYYY-MM-DD"

  DeviceMeasurement copyWith({
    double? netWeight,
    double? tareWeight,
    double? grossWeight,
    String? weightUnitName,
    String? weightUnitAbbreviation,
    String? calibrationDate,
  }) {
    return DeviceMeasurement(
      netWeight: netWeight ?? this.netWeight,
      tareWeight: tareWeight ?? this.tareWeight,
      grossWeight: grossWeight ?? this.grossWeight,
      weightUnitName: weightUnitName ?? this.weightUnitName,
      weightUnitAbbreviation:
          weightUnitAbbreviation ?? this.weightUnitAbbreviation,
      calibrationDate: calibrationDate ?? this.calibrationDate,
    );
  }
}
