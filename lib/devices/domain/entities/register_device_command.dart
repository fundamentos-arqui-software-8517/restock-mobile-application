class RegisterDeviceCommand {
  const RegisterDeviceCommand({
    required this.accountId,
    required this.macAddress,
    required this.description,
  });

  final String accountId;
  final String macAddress;
  final String description;
}
