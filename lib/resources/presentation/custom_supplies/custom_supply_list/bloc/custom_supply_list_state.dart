import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class CustomSupplyListState {
  final Status status;
  final List<CustomSupply> customSupplies;
  final String? message;

  const CustomSupplyListState({
    this.status = Status.initial,
    this.customSupplies = const [],
    this.message,
  });

  CustomSupplyListState copyWith({
    Status? status,
    List<CustomSupply>? customSupplies,
    String? message,
  }) {
    return CustomSupplyListState(
      status: status ?? this.status,
      customSupplies: customSupplies ?? this.customSupplies,
      message: message ?? this.message,
    );
  }
}