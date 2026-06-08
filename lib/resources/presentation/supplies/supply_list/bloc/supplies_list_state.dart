import 'package:restock/resources/domain/entities/supply.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

/// State class for managing the state of the supplies list in the BLoC pattern.
class SuppliesListState {
  final Status status;
  final List<Supply> supplies;
  final String? message;

  /// Creates a new instance of [SuppliesListState] with the given parameters.
  const SuppliesListState({
    this.status = Status.initial,
    this.supplies = const [],
    this.message,
  });

  /// Creates a copy of the current state with optional new values for each property.
  SuppliesListState copyWith({
    Status? status,
    List<Supply>? supplies,
    String? message,
  }) {
    return SuppliesListState(
      status: status ?? this.status,
      supplies: supplies ?? this.supplies,
      message: message ?? this.message,
    );
  }
}