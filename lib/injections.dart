import 'package:get_it/get_it.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/resources/application/custom_supply_facade_service.dart';
import 'package:restock/resources/domain/repositories/branch_repository.dart';
import 'package:restock/resources/domain/repositories/custom_supply_repository.dart';
import 'package:restock/resources/infrastructure/data_sources/branch_remote_data_provider.dart';
import 'package:restock/resources/infrastructure/data_sources/custom_supply_remote_data_provider.dart';
import 'package:restock/resources/infrastructure/repositories/branch_repository_impl.dart';
import 'package:restock/resources/infrastructure/repositories/custom_supply_repository_impl.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_bloc.dart';

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

  // Custom Supply
  serviceLocator.registerLazySingleton<CustomSupplyFacadeService>(
    () => CustomSupplyFacadeService(
      customSupplyRepository: serviceLocator<CustomSupplyRepository>(),
    ),
  );

  // Branch
  serviceLocator.registerLazySingleton<BranchFacadeService>(
    () => BranchFacadeService(
      branchRepository: serviceLocator<BranchRepository>(),
    ),
  );

  // Infrastructure layer (Repositories and Data Providers)

  // Custom Supply
  serviceLocator.registerLazySingleton<CustomSupplyRemoteDataProvider>(
    () => CustomSupplyRemoteDataProvider(),
  );

  serviceLocator.registerLazySingleton<CustomSupplyRepository>(
    () => CustomSupplyRepositoryImpl(
      customSupplyRemoteDataProvider:
          serviceLocator<CustomSupplyRemoteDataProvider>(),
    ),
  );

  // Branch
  serviceLocator.registerLazySingleton<BranchRemoteDataProvider>(
    () => BranchRemoteDataProvider(),
  );

  serviceLocator.registerLazySingleton<BranchRepository>(
    () => BranchRepositoryImpl(
      branchRemoteDataProvider:
          serviceLocator<BranchRemoteDataProvider>(),
    ),
  );

  // Presentation layer
  
  // Custom Supply List Bloc
  serviceLocator.registerFactory<CustomSupplyListBloc>(
    () => CustomSupplyListBloc(
      customSupplyFacadeService: serviceLocator<CustomSupplyFacadeService>(),
    ),
  );

  // Branch List Bloc
  serviceLocator.registerFactory<BranchListBloc>(
    () => BranchListBloc(
      branchFacadeService: serviceLocator<BranchFacadeService>(),
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
