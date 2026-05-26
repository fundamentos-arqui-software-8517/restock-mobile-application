import 'package:get_it/get_it.dart';

/// Service locator for dependency injection.
final serviceLocator = GetIt.instance;

/// Sets up all the dependencies for the application.
Future<void> setupDependencies() async {
  await iamDependencies();
  await profileDependencies();
  await analyticsDependencies();
  await armDependencies();
  await communicationsDependencies();
  await subscriptionsDependencies();
  await trackingDependencies();
}

/// Configures the dependencies for the IAM context.
Future<void> iamDependencies() async {
  // For example:
  // serviceLocator.registerLazySingleton<YourService>(() => YourServiceImpl());
}

/// Configures the dependencies for the Profile context.
Future<void> profileDependencies() async {
  // For example:
  // serviceLocator.registerLazySingleton<YourProfileService>(() => YourProfileServiceImpl());
}

/// Configures the dependencies for the Analytics context.
Future<void> analyticsDependencies() async {
  // For example:
  // serviceLocator.registerLazySingleton<YourAnalyticsService>(() => YourAnalyticsServiceImpl());
}

/// Configures the dependencies for the ARM context.
Future<void> armDependencies() async {
  // For example:
  // serviceLocator.registerLazySingleton<YourArmService>(() => YourArmServiceImpl());
}

/// Configures the dependencies for the Communications context.
Future<void> communicationsDependencies() async {
  // For example:
  // serviceLocator.registerLazySingleton<YourCommunicationService>(() => YourCommunicationServiceImpl());
}

/// Configures the dependencies for the Subscriptions context.
Future<void> subscriptionsDependencies() async {
  // For example:
  // serviceLocator.registerLazySingleton<YourSubscriptionService>(() => YourSubscriptionServiceImpl());
}

/// Configures the dependencies for the Subscriptions context.
Future<void> trackingDependencies() async {
  // For example:
  // serviceLocator.registerLazySingleton<YourTrackingService>(() => YourTrackingServiceImpl());
}