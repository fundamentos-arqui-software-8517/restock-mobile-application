import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Callback types for notification handling
typedef OnMessageReceived = void Function(RemoteMessage message);
typedef OnNotificationTapped = void Function(RemoteMessage message);

/// A service class to handle push notifications using Firebase Cloud Messaging (FCM).
class PushNotificationService {
  static const _androidNotificationIcon = 'ic_stat_restock_notification';

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  OnMessageReceived? onForegroundMessage;
  OnNotificationTapped? onNotificationTapped;

  final _tokenController = StreamController<String>.broadcast();
  Stream<String> get tokenStream => _tokenController.stream;

  bool _initialized = false;
  String? _currentToken;
  String? get currentToken => _currentToken;

  String get clientPlatform {
    if (Platform.isAndroid) return 'ANDROID';
    if (Platform.isIOS) return 'IOS';
    return 'UNKNOWN';
  }

  /// Initializes the push notification service.
  Future<void> initialize({
    OnMessageReceived? onForeground,
    OnNotificationTapped? onTapped,
  }) async {
    onForegroundMessage = onForeground;
    onNotificationTapped = onTapped;

    if (_initialized) {
      await _fetchAndStoreToken();
      return;
    }

    await _requestPermission();
    await _initLocalNotifications();
    await _fetchAndStoreToken();
    _listenTokenRefresh();
    _listenForegroundMessages();
    await _handleInitialMessage();
    _initialized = true;
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings(
      '@drawable/$_androidNotificationIcon',
    );
    const ios = DarwinInitializationSettings();

    await _localNotifications.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (details) {},
    );

    const channel = AndroidNotificationChannel(
      'restock_high_importance',
      'Restock Notifications',
      description: 'Restock Notifications',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _fetchAndStoreToken() async {
    final token = await getToken();
    if (token != null) {
      _currentToken = token;
    }
  }

  Future<String?> getToken() async {
    return _messaging.getToken();
  }

  void _listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) {
      _currentToken = newToken;
      _tokenController.add(newToken);
    });
  }

  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((message) {
      onForegroundMessage?.call(message);
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onNotificationTapped?.call(message);
    });
  }

  Future<void> _handleInitialMessage() async {
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      onNotificationTapped?.call(initial);
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    final title =
        _firstNonEmpty([
          notification?.title,
          message.data['title'],
          message.data['notificationTitle'],
        ]) ??
        _fallbackTitleFor(message);
    final body =
        _firstNonEmpty([
          notification?.body,
          message.data['body'],
          message.data['message'],
          message.data['content'],
        ]) ??
        _fallbackBodyFor(message);

    _localNotifications.show(
      id: message.messageId.hashCode,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'restock_high_importance',
          'Restock Notifications',
          channelDescription: 'Restock Notifications',
          icon: _androidNotificationIcon,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
    );
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final normalized = value?.trim();
      if (normalized != null && normalized.isNotEmpty) return normalized;
    }
    return null;
  }

  String _fallbackBodyFor(RemoteMessage message) {
    final eventName = _eventNameFor(message);
    final macAddress = _macAddressFor(message);
    if (eventName == 'InventoryBelowMinimumStockEvent') {
      return 'Inventory is below minimum stock.';
    }
    if (eventName == 'DeviceRegisteredEvent' && macAddress != null) {
      return 'Device with the mac address $macAddress has been registered successfully';
    }
    if (eventName == 'DeviceConfiguredEvent' && macAddress != null) {
      return 'Device with the mac address $macAddress has been configured successfully';
    }
    if (eventName == 'DeviceCalibratedEvent' && macAddress != null) {
      return 'Device with the mac address $macAddress has been calibrated successfully';
    }
    return 'Open Restock for details.';
  }

  String _fallbackTitleFor(RemoteMessage message) {
    final eventName = _eventNameFor(message);
    final macAddress = _macAddressFor(message);
    if (eventName == 'DeviceRegisteredEvent' && macAddress != null) {
      return 'New device registered $macAddress';
    }
    if (eventName == 'DeviceConfiguredEvent' && macAddress != null) {
      return 'New device configured $macAddress';
    }
    if (eventName == 'DeviceCalibratedEvent' && macAddress != null) {
      return 'New device calibrated $macAddress';
    }
    return 'Restock alert';
  }

  String? _eventNameFor(RemoteMessage message) {
    return _firstNonEmpty([
      message.data['event'],
      message.data['eventName'],
      message.data['eventType'],
      message.data['type'],
      message.data['notificationEvent'],
    ]);
  }

  String? _macAddressFor(RemoteMessage message) {
    return _firstNonEmpty([
      message.data['macAddress'],
      message.data['sourceId'],
    ]);
  }

  void dispose() {
    _tokenController.close();
  }
}
