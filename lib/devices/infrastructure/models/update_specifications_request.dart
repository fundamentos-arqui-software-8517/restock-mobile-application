class UpdateSpecificationsRequest {
  const UpdateSpecificationsRequest({
    required this.manufacturer,
    required this.model,
    required this.firmwareVersion,
  });

  final String manufacturer;
  final String model;
  final String firmwareVersion;

  Map<String, dynamic> toJson() => {
        'manufacturer': manufacturer,
        'model': model,
        'firmwareVersion': firmwareVersion,
      };
}
