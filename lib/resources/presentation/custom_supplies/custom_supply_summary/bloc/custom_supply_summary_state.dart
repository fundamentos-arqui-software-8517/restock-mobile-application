import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class CustomSupplySummaryState {
  const CustomSupplySummaryState({
    this.status = Status.initial,
    this.customSupply,
    this.message,
  });

  final Status status;
  final CustomSupply? customSupply;
  final String? message;

  CustomSupplySummaryState copyWith({
    Status? status,
    CustomSupply? customSupply,
    String? message,
  }) {
    return CustomSupplySummaryState(
      status: status ?? this.status,
      customSupply: customSupply ?? this.customSupply,
      message: message ?? this.message,
    );
  }
}
