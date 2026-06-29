import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:restock/communications/infrastructure/data_sources/push_subscription_remote_data_provider.dart';
import 'package:restock/communications/infrastructure/models/push_subscription_request.dart';
import 'package:restock/communications/infrastructure/notifications/push_notifications_service.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

class CommunicationsFacadeService {
  CommunicationsFacadeService({
    required this.pushNotificationsService,
    required this.pushSubscriptionRemoteDataProvider,
    required this.tokenStorage,
  });

  static const _provider = 'FCM';

  final PushNotificationService pushNotificationsService;
  final PushSubscriptionRemoteDataProvider pushSubscriptionRemoteDataProvider;
  final TokenStorage tokenStorage;

  StreamSubscription<String>? _tokenRefreshSubscription;

  Future<void> registerCurrentDeviceForUser(String userId) async {
    await pushNotificationsService.initialize();
    final providerToken =
        pushNotificationsService.currentToken ??
        await pushNotificationsService.getToken();

    if (providerToken == null || providerToken.isEmpty) {
      debugPrint('[CommunicationsFacadeService] FCM token is not available');
      return;
    }

    await _registerPushSubscription(
      userId: userId,
      providerToken: providerToken,
    );
    _listenTokenRefresh();
  }

  void _listenTokenRefresh() {
    _tokenRefreshSubscription ??= pushNotificationsService.tokenStream.listen((
      providerToken,
    ) async {
      final userId = await tokenStorage.readAccountId();
      if (userId == null || userId.isEmpty) return;

      try {
        await _registerPushSubscription(
          userId: userId,
          providerToken: providerToken,
        );
      } catch (e) {
        debugPrint(
          '[CommunicationsFacadeService] Failed to register refreshed token: $e',
        );
      }
    });
  }

  Future<void> _registerPushSubscription({
    required String userId,
    required String providerToken,
  }) async {
    await pushSubscriptionRemoteDataProvider.register(
      PushSubscriptionRequest(
        userId: userId,
        providerToken: providerToken,
        clientPlatform: pushNotificationsService.clientPlatform,
        provider: _provider,
      ),
    );
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    pushNotificationsService.dispose();
  }
}
