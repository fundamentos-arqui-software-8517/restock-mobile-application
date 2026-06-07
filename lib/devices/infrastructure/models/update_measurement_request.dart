class UpdateMeasurementRequest {
  const UpdateMeasurementRequest({
    required this.weightUnit,
    required this.unitWeight,
    required this.tareWeight,
    this.calibrationDate,
  });

  final String weightUnit;
  final double unitWeight;
  final double tareWeight;
  final DateTime? calibrationDate;

  Map<String, dynamic> toJson() => {
        'weightUnit': weightUnit,
        'unitWeight': unitWeight,
        'tareWeight': tareWeight,
        if (calibrationDate != null)
          'calibrationDate': calibrationDate!.toIso8601String(),
      };
}
