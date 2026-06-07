class AssignBatchRequest {
  const AssignBatchRequest({required this.customSupplyId});

  final String customSupplyId;

  Map<String, dynamic> toJson() => {'customSupplyId': customSupplyId};
}
