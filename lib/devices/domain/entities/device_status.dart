enum DeviceStatus {
  registered,
  configured,
  calibrated,
  active,
  inactive;

  String toApiString() => name.toUpperCase();

  static DeviceStatus fromApi(String value) => values.firstWhere(
    (e) => e.name.toUpperCase() == value.toUpperCase(),
    orElse: () => DeviceStatus.registered,
  );
}
