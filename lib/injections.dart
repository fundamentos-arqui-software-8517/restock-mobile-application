import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:restock/devices/application/device_facade_service.dart';
import 'package:restock/devices/application/device_threshold_facade_service.dart';
import 'package:restock/devices/domain/repositories/batch_repository.dart';
import 'package:restock/devices/domain/repositories/device_repository.dart';
import 'package:restock/devices/domain/repositories/device_threshold_repository.dart';
import 'package:restock/devices/infrastructure/data_sources/batch_remote_data_provider.dart';
import 'package:restock/devices/infrastructure/data_sources/device_remote_data_provider.dart';
import 'package:restock/devices/infrastructure/data_sources/device_threshold_remote_data_provider.dart';
import 'package:restock/devices/infrastructure/repositories/batch_repository_impl.dart';
import 'package:restock/devices/infrastructure/repositories/device_repository_impl.dart';
import 'package:restock/devices/infrastructure/repositories/device_threshold_repository_impl.dart';
import 'package:restock/devices/presentation/views/device_detail/bloc/device_detail_bloc.dart';
import 'package:restock/devices/presentation/views/device_list/bloc/device_list_bloc.dart';
import 'package:restock/iam/application/iam_facade_service.dart';
import 'package:restock/iam/domain/repositories/auth_repository.dart';
import 'package:restock/iam/infrastructure/data_sources/auth_remote_data_provider.dart';
import 'package:restock/iam/infrastructure/interceptor/auth_http_client.dart';
import 'package:restock/iam/infrastructure/repositories/auth_repository_impl.dart';
import 'package:restock/iam/presentation/views/sign_in_form/bloc/sign_in_form_bloc.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/resources/application/custom_supply_facade_service.dart';
import 'package:restock/resources/application/supply_facade_service.dart';
import 'package:restock/resources/domain/repositories/branch_repository.dart';
import 'package:restock/resources/domain/repositories/custom_supply_repository.dart';
import 'package:restock/resources/domain/repositories/supply_repository.dart';
import 'package:restock/resources/infrastructure/data_sources/branch_local_data_provider.dart';
import 'package:restock/resources/infrastructure/data_sources/branch_remote_data_provider.dart';
import 'package:restock/resources/infrastructure/data_sources/custom_supply_local_data_provider.dart';
import 'package:restock/resources/infrastructure/data_sources/custom_supply_remote_data_provider.dart';
import 'package:restock/resources/infrastructure/data_sources/supply_local_data_provider.dart';
import 'package:restock/resources/infrastructure/data_sources/supply_remote_data_provider.dart';
import 'package:restock/resources/infrastructure/repositories/branch_repository_impl.dart';
import 'package:restock/resources/infrastructure/repositories/custom_supply_repository_impl.dart';
import 'package:restock/resources/infrastructure/repositories/supply_repository_impl.dart';
import 'package:restock/resources/presentation/branches/branch_detail/bloc/branch_detail_bloc.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_bloc.dart';
import 'package:restock/resources/presentation/branches/branch_status/bloc/branch_status_bloc.dart';
import 'package:restock/resources/presentation/branches/create_and_edit_branch/blocs/create_and_edit_branch_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/create_and_edit_custom_supply/bloc/create_and_edit_custom_supply_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/custom_supply_list/bloc/custom_supply_list_bloc.dart';
import 'package:restock/shared/infrastructure/database/local_database.dart';
import 'package:restock/shared/infrastructure/services/auth_status_notifier.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

/// Service locator for dependency injection.
final serviceLocator = GetIt.instance;

/// Sets up all the dependencies for the application.
Future<void> setupDependencies() async {
  await secureStorageDependencies();
  await localDatabase();
  await iamDependencies();
  await profileDependencies();
  await analyticsDependencies();
  await rmDependencies();
  await communicationsDependencies();
  await subscriptionsDependencies();
  await trackingDependencies();
  await devicesDependencies();
}

// Secure Storage
Future<void> secureStorageDependencies() async {
  serviceLocator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );

  serviceLocator.registerLazySingleton<TokenStorage>(() => TokenStorage());

  serviceLocator.registerLazySingleton<AuthStatusNotifier>(
    () => AuthStatusNotifier(tokenStorage: serviceLocator<TokenStorage>()),
  );
}

Future<void> localDatabase() async {
  serviceLocator.registerLazySingleton<AppDatabase>(() => AppDatabase());
}

/// Configures the dependencies for the IAM context.
Future<void> iamDependencies() async {
  // Application layer (Facade services)

  // Authentication
  serviceLocator.registerLazySingleton<AuthFacadeService>(
    () => AuthFacadeService(
      authRepository: serviceLocator<AuthRepository>(),
      tokenStorage: serviceLocator<TokenStorage>(),
      authStatusNotifier: serviceLocator<AuthStatusNotifier>(),
    ),
  );

  // Infrastructure layer (Repositories and Data Providers)

  // Authentication
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataProvider: serviceLocator<AuthRemoteDataProvider>(),
    ),
  );

  serviceLocator.registerLazySingleton<AuthRemoteDataProvider>(
    () => AuthRemoteDataProvider(),
  );

  // Presentation layer

  // Authentication - Sign In
  serviceLocator.registerFactory<SignInBloc>(
    () => SignInBloc(authFacadeService: serviceLocator<AuthFacadeService>()),
  );

  serviceLocator.registerLazySingleton<AuthHttpClient>(
    () => AuthHttpClient(
      tokenStorage: serviceLocator<TokenStorage>(),
      authStatusNotifier: serviceLocator<AuthStatusNotifier>(),
    ),
  );
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
      tokenStorage: serviceLocator<TokenStorage>(),
    ),
  );

  serviceLocator.registerLazySingleton<SupplyFacadeService>(
    () => SupplyFacadeService(
      supplyRepository: serviceLocator<SupplyRepository>(),
    ),
  );

  // Branch
  serviceLocator.registerLazySingleton<BranchFacadeService>(
    () => BranchFacadeService(
      branchRepository: serviceLocator<BranchRepository>(),
      tokenStorage: serviceLocator<TokenStorage>(),
    ),
  );

  // Infrastructure layer (Repositories and Data Providers)

  // Custom Supply
  serviceLocator.registerLazySingleton<CustomSupplyRemoteDataProvider>(
    () =>
        CustomSupplyRemoteDataProvider(http: serviceLocator<AuthHttpClient>()),
  );

  serviceLocator.registerLazySingleton<CustomSupplyLocalDataProvider>(
    () => CustomSupplyLocalDataProvider(
      appDatabase: serviceLocator<AppDatabase>(),
    ),
  );

  serviceLocator.registerLazySingleton<CustomSupplyRepository>(
    () => CustomSupplyRepositoryImpl(
      customSupplyRemoteDataProvider:
          serviceLocator<CustomSupplyRemoteDataProvider>(),
      customSupplyLocalDataProvider:
          serviceLocator<CustomSupplyLocalDataProvider>(),
      supplyRemoteDataProvider: serviceLocator<SupplyRemoteDataProvider>(),
      supplyLocalDataProvider: serviceLocator<SupplyLocalDataProvider>(),
    ),
  );

  // Supply
  serviceLocator.registerLazySingleton<SupplyRemoteDataProvider>(
    () => SupplyRemoteDataProvider(http: serviceLocator<AuthHttpClient>()),
  );

  serviceLocator.registerLazySingleton<SupplyLocalDataProvider>(
    () => SupplyLocalDataProvider(appDatabase: serviceLocator<AppDatabase>()),
  );

  serviceLocator.registerLazySingleton<SupplyRepository>(
    () => SupplyRepositoryImpl(
      supplyRemoteDataProvider: serviceLocator<SupplyRemoteDataProvider>(),
      supplyLocalDataProvider: serviceLocator<SupplyLocalDataProvider>(),
    ),
  );

  // Branch
  serviceLocator.registerLazySingleton<BranchRemoteDataProvider>(
    () => BranchRemoteDataProvider(http: serviceLocator<AuthHttpClient>()),
  );

  serviceLocator.registerLazySingleton<BranchLocalDataProvider>(
    () => BranchLocalDataProvider(appDatabase: serviceLocator<AppDatabase>()),
  );

  serviceLocator.registerLazySingleton<BranchRepository>(
    () => BranchRepositoryImpl(
      branchRemoteDataProvider: serviceLocator<BranchRemoteDataProvider>(),
      branchLocalDataProvider: serviceLocator<BranchLocalDataProvider>(),
    ),
  );

  // Presentation layer

  // Custom Supply List Bloc
  serviceLocator.registerFactory<CustomSupplyListBloc>(
    () => CustomSupplyListBloc(
      customSupplyFacadeService: serviceLocator<CustomSupplyFacadeService>(),
    ),
  );

  serviceLocator.registerFactory<CreateCustomSupplyBloc>(
    () => CreateCustomSupplyBloc(
      customSupplyFacadeService: serviceLocator<CustomSupplyFacadeService>(),
    ),
  );

  // Branch List Bloc
  serviceLocator.registerFactory<BranchListBloc>(
    () => BranchListBloc(
      branchFacadeService: serviceLocator<BranchFacadeService>(),
    ),
  );

  serviceLocator.registerFactory<BranchDetailBloc>(
    () => BranchDetailBloc(
      branchFacadeService: serviceLocator<BranchFacadeService>(),
    ),
  );

  serviceLocator.registerFactory<CreateAndEditBranchBloc>(
    () => CreateAndEditBranchBloc(
      branchFacadeService: serviceLocator<BranchFacadeService>(),
    ),
  );

  serviceLocator.registerFactory<UpdateBranchStatusBloc>(
    () => UpdateBranchStatusBloc(
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

/// Configures the dependencies for the Devices context (EP-09).
Future<void> devicesDependencies() async {
  // Infrastructure
  serviceLocator.registerLazySingleton<DeviceRemoteDataProvider>(
    () => DeviceRemoteDataProvider(http: serviceLocator<AuthHttpClient>()),
  );
  serviceLocator.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(
      deviceRemoteDataProvider: serviceLocator<DeviceRemoteDataProvider>(),
    ),
  );

  serviceLocator.registerLazySingleton<BatchRemoteDataProvider>(
    () => BatchRemoteDataProvider(http: serviceLocator<AuthHttpClient>()),
  );
  serviceLocator.registerLazySingleton<BatchRepository>(
    () => BatchRepositoryImpl(
      remoteDataProvider: serviceLocator<BatchRemoteDataProvider>(),
    ),
  );

  // Application
  serviceLocator.registerLazySingleton<DeviceFacadeService>(
    () => DeviceFacadeService(
      deviceRepository: serviceLocator<DeviceRepository>(),
      batchRepository: serviceLocator<BatchRepository>(),
      thresholdRepository: serviceLocator<DeviceThresholdRepository>(),
      branchFacadeService: serviceLocator<BranchFacadeService>(),
      tokenStorage: serviceLocator<TokenStorage>(),
    ),
  );

  // Presentation
  serviceLocator.registerFactory<DeviceListBloc>(
    () => DeviceListBloc(
      deviceFacadeService: serviceLocator<DeviceFacadeService>(),
    ),
  );
  serviceLocator.registerFactory<DeviceDetailBloc>(
    () => DeviceDetailBloc(
      deviceFacadeService: serviceLocator<DeviceFacadeService>(),
      deviceThresholdFacadeService:
          serviceLocator<DeviceThresholdFacadeService>(),
    ),
  );

  // Thresholds (M4)
  serviceLocator.registerLazySingleton<DeviceThresholdRemoteDataProvider>(
    () => DeviceThresholdRemoteDataProvider(
      http: serviceLocator<AuthHttpClient>(),
    ),
  );
  serviceLocator.registerLazySingleton<DeviceThresholdRepository>(
    () => DeviceThresholdRepositoryImpl(
      remoteDataProvider:
          serviceLocator<DeviceThresholdRemoteDataProvider>(),
    ),
  );
  serviceLocator.registerLazySingleton<DeviceThresholdFacadeService>(
    () => DeviceThresholdFacadeService(
      thresholdRepository: serviceLocator<DeviceThresholdRepository>(),
      deviceRepository: serviceLocator<DeviceRepository>(),
      tokenStorage: serviceLocator<TokenStorage>(),
    ),
  );
}
