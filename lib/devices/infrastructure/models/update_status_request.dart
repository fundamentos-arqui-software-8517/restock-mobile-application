class UpdateStatusRequest {
  const UpdateStatusRequest({required this.status});

  final String status;

  Map<String, dynamic> toJson() => {'status': status};
}
