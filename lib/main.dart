import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:restock/l10n/app_localizations.dart';
import 'package:restock/communications/infrastructure/notifications/push_notifications_service.dart';
import 'package:restock/shared/infrastructure/services/auth_status_notifier.dart';
import './injections.dart' as di;
import 'package:restock/shared/infrastructure/navigation/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// The main function is the entry point of the application. It initializes the dependency injection and runs the app.
Future<void> main() async {
  /// Ensures that Flutter bindings are initialized before running the app. This is necessary for any asynchronous operations that need to be performed before the app starts, such as initializing Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  /// Initializes Firebase with the default options for the current platform. This is required to use Firebase services such as Cloud Messaging for push notifications.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Sets up the dependencies for the application using the dependency injection (DI) system defined in the `injections.dart` file. This typically involves registering services, repositories, and other dependencies that the app will use.
  await di.setupDependencies();

  /// Initializes the `AuthStatusNotifier` service, which is responsible for managing the authentication status of the user. This may involve checking if the user is already authenticated, refreshing tokens, or setting up listeners for authentication state changes.
  await di.serviceLocator<AuthStatusNotifier>().initialize();

  /// Runs the main application widget, which is defined in the `RestockApp` class. This will start the Flutter application and display the user interface.
  runApp(const RestockApp());

  /// Push notifications must not block the first frame. On distributed builds,
  /// FCM token or permission setup can fail before Flutter paints the sign in.
  unawaited(_initializePushNotifications());
}

Future<void> _initializePushNotifications() async {
  try {
    await di.serviceLocator<PushNotificationService>().initialize(
      onForeground: (message) {},
      onTapped: (message) {},
    );
  } catch (error, stackTrace) {
    debugPrint('Push notification initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

// TODO(i18n): mover a un locale/settings bloc en la pasada completa.
final localeNotifier = ValueNotifier<Locale>(const Locale('en'));

/// The main application widget.
class RestockApp extends StatelessWidget {
  const RestockApp({super.key});

  /// Builds the MaterialApp with the specified title, theme, and router configuration.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, locale, _) {
        return MaterialApp.router(
          title: 'Restock',
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          routerConfig: buildRouter(di.serviceLocator<AuthStatusNotifier>()),
        );
      },
    );
  }
}

/// A background message handler for Firebase Cloud Messaging (FCM). This function is called when a message is received while the app is in the background or terminated. It initializes Firebase to ensure that the app can handle the incoming message properly.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
