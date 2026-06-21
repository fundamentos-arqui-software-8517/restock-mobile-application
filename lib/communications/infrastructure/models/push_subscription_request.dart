class PushSubscriptionRequest {
  const PushSubscriptionRequest({
    required this.userId,
    required this.providerToken,
    required this.clientPlatform,
    required this.provider,
  });

  final String userId;
  final String providerToken;
  final String clientPlatform;
  final String provider;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'providerToken': providerToken,
      'clientPlatform': clientPlatform,
      'provider': provider,
    };
  }
}
