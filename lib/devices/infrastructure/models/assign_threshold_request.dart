import 'package:restock/devices/domain/entities/assign_threshold_command.dart';

class AssignThresholdRequest {
  const AssignThresholdRequest({required this.thresholdId});

  factory AssignThresholdRequest.fromCommand(AssignThresholdCommand cmd) =>
      AssignThresholdRequest(thresholdId: cmd.thresholdId);

  final String thresholdId;

  Map<String, dynamic> toJson() => {'thresholdId': thresholdId};
}
