import 'package:get_it/get_it.dart';
import 'package:restock/resources/application/resource_management_facade_service.dart';
import 'package:restock/resources/domain/repositories/custom_supply_repository.dart';
import 'package:restock/resources/infrastructure/data_sources/custom_supply_remote_data_provider.dart';
import 'package:restock/resources/infrastructure/repositories/custom_supply_repository_impl.dart';
import 'package:restock/resources/presentation/custom_supply_list/bloc/custom_supply_list_bloc.dart';

/// Service locator for dependency injection.
final serviceLocator = GetIt.instance;

/// Sets up all the dependencies for the application.
Future<void> setupDependencies() async {
  await iamDependencies();
  await profileDependencies();
  await analyticsDependencies();
  await rmDependencies();
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
Future<void> rmDependencies() async {
  // Application layer (Facade services)
  serviceLocator.registerLazySingleton<ResourceManagementFacadeService>(
    () => ResourceManagementFacadeService(
      customSupplyRepository: serviceLocator<CustomSupplyRepository>(),
    ),
  );

  // Infrastructure layer (Repositories and Data Providers)
  serviceLocator.registerLazySingleton<CustomSupplyRemoteDataProvider>(
    () => CustomSupplyRemoteDataProvider(),
  );

  serviceLocator.registerLazySingleton<CustomSupplyRepository>(
    () => CustomSupplyRepositoryImpl(
      customSupplyRemoteDataProvider:
          serviceLocator<CustomSupplyRemoteDataProvider>(),
    ),
  );

  // Presentation layer
  serviceLocator.registerFactory<CustomSupplyListBloc>(
    () => CustomSupplyListBloc(
      rmFacadeService: serviceLocator<ResourceManagementFacadeService>(),
    ),
  );
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
