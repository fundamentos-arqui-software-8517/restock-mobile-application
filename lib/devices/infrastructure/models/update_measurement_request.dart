class UpdateMeasurementRequest {
  const UpdateMeasurementRequest({
    required this.netWeight,
    required this.tareWeight,
    required this.grossWeight,
    required this.calibrationDate,
    required this.weightUnitName,
    required this.weightUnitAbbreviation,
  });

  final double netWeight;
  final double tareWeight;
  final double grossWeight;
  final String calibrationDate;
  final String weightUnitName;
  final String weightUnitAbbreviation;

  Map<String, dynamic> toJson() => {
        'netWeight': netWeight,
        'tareWeight': tareWeight,
        'grossWeight': grossWeight,
        'calibrationDate': calibrationDate,
        'weightUnitName': weightUnitName,
        'weightUnitAbbreviation': weightUnitAbbreviation,
      };
}
