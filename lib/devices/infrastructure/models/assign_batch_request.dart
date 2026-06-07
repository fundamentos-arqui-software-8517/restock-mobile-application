class AssignBatchRequest {
  const AssignBatchRequest({required this.batchId});

  final String batchId;

  Map<String, dynamic> toJson() => {'batchId': batchId};
}
