import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class CustomSupplyListState {
  final Status status;
  final List<CustomSupply> customSupplies;
  final String searchQuery;
  final String? message;

  const CustomSupplyListState({
    this.status = Status.initial,
    this.customSupplies = const [],
    this.searchQuery = '',
    this.message,
  });

  List<CustomSupply> get filteredCustomSupplies {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return customSupplies;

    return customSupplies.where((supply) {
      return supply.name.toLowerCase().contains(query) ||
          supply.description.toLowerCase().contains(query) ||
          supply.category.toLowerCase().contains(query) ||
          supply.supply.name.toLowerCase().contains(query) ||
          supply.supply.description.toLowerCase().contains(query);
    }).toList();
  }

  bool get isSearching => searchQuery.trim().isNotEmpty;

  CustomSupplyListState copyWith({
    Status? status,
    List<CustomSupply>? customSupplies,
    String? searchQuery,
    String? message,
  }) {
    return CustomSupplyListState(
      status: status ?? this.status,
      customSupplies: customSupplies ?? this.customSupplies,
      searchQuery: searchQuery ?? this.searchQuery,
      message: message ?? this.message,
    );
  }
}
