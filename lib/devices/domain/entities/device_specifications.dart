class DeviceSpecifications {
  const DeviceSpecifications({
    required this.manufacturer,
    required this.model,
    required this.firmwareVersion,
  });

  final String manufacturer;
  final String model;
  final String firmwareVersion;

  static const DeviceSpecifications defaults = DeviceSpecifications(
    manufacturer: 'Restock',
    model: 'Supply Keeper',
    firmwareVersion: '1.0.0',
  );
}
