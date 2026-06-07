import 'package:restock/devices/domain/entities/create_threshold_command.dart';
import 'package:restock/devices/domain/entities/device_threshold.dart';
import 'package:restock/devices/domain/repositories/device_threshold_repository.dart';
import 'package:restock/devices/infrastructure/data_sources/device_threshold_remote_data_provider.dart';
import 'package:restock/devices/infrastructure/models/create_threshold_request.dart';

class DeviceThresholdRepositoryImpl implements DeviceThresholdRepository {
  const DeviceThresholdRepositoryImpl({required this.remoteDataProvider});

  final DeviceThresholdRemoteDataProvider remoteDataProvider;

  @override
  Future<List<DeviceThreshold>> getThresholdsByAccountId(
    String accountId,
  ) async {
    try {
      final response =
          await remoteDataProvider.getThresholdsByAccountId(accountId);
      return response.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to get thresholds: $e');
    }
  }

  @override
  Future<DeviceThreshold> getThresholdById(String thresholdId) async {
    try {
      final response = await remoteDataProvider.getThresholdById(thresholdId);
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to get threshold: $e');
    }
  }

  @override
  Future<DeviceThreshold> createThreshold(
    CreateThresholdCommand command,
  ) async {
    try {
      final request = CreateThresholdRequest.fromCommand(command);
      final response = await remoteDataProvider.createThreshold(request);
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to create threshold: $e');
    }
  }
}
