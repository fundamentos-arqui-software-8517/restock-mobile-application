class RegisterDeviceRequest {
  const RegisterDeviceRequest({
    required this.accountId,
    required this.macAddress,
    required this.description,
  });

  final String accountId;
  final String macAddress;
  final String description;

  Map<String, dynamic> toJson() => {
        'accountId': accountId,
        'macAddress': macAddress,
        'description': description,
      };
}
