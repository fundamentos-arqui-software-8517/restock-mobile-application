import 'package:restock/resources/domain/entities/batch.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_event.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class BatchListState {
  const BatchListState({
    this.status = Status.initial,
    this.batches = const [],
    this.searchQuery = '',
    this.stockFilter = BatchStockFilter.any,
    this.categoryFilterKey,
    this.customSupplyNamesById = const {},
    this.message,
  });

  final Status status;
  final List<Batch> batches;
  final String searchQuery;
  final BatchStockFilter stockFilter;
  final String? categoryFilterKey;
  final Map<String, String> customSupplyNamesById;
  final String? message;

  List<Batch> get filteredBatches {
    final normalizedQuery = searchQuery.trim().toLowerCase();

    return batches.where((batch) {
      final matchesSearch =
          normalizedQuery.isEmpty ||
          batch.code.toLowerCase().contains(normalizedQuery) ||
          batch.customSupplyId.toLowerCase().contains(normalizedQuery) ||
          (batch.customSupplyName?.toLowerCase().contains(normalizedQuery) ??
              false);

      if (!matchesSearch) return false;

      final categoryKey = categoryFilterKey;
      if (categoryKey != null && batch.customSupplyId != categoryKey) {
        return false;
      }

      return switch (stockFilter) {
        BatchStockFilter.any => true,
        BatchStockFilter.low =>
          batch.minimumStock != null
              ? batch.currentStock <= batch.minimumStock!
              : batch.currentStock <= 0,
        BatchStockFilter.available => batch.currentStock > 0,
      };
    }).toList();
  }

  bool get isFiltering =>
      searchQuery.trim().isNotEmpty ||
      stockFilter != BatchStockFilter.any ||
      categoryFilterKey != null;

  List<BatchCategoryOption> get categoryOptions {
    final options = <String, BatchCategoryOption>{};

    for (final entry in customSupplyNamesById.entries) {
      final name = entry.value.trim();
      if (name.isEmpty) continue;
      options.putIfAbsent(
        entry.key,
        () => BatchCategoryOption(key: entry.key, label: name),
      );
    }

    for (final batch in batches) {
      options.putIfAbsent(
        batch.customSupplyId,
        () => BatchCategoryOption(
          key: batch.customSupplyId,
          label: _categoryLabel(batch, customSupplyNamesById),
        ),
      );
    }

    final values = options.values.toList()
      ..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
    return values;
  }

  String get selectedCategoryLabel {
    final key = categoryFilterKey;
    if (key == null) return 'All Categories';

    for (final option in categoryOptions) {
      if (option.key == key) return option.label;
    }

    return 'All Categories';
  }

  bool get requiresBranchSelection =>
      status == Status.failure &&
      (message?.contains('Active branch ID not found') ?? false);

  int get nearExpiryCount {
    final now = DateTime.now();
    final limit = now.add(const Duration(days: 30));

    return batches.where((batch) {
      final expirationDate = batch.expirationDate;
      if (expirationDate == null) return false;

      return !expirationDate.isBefore(now) && !expirationDate.isAfter(limit);
    }).length;
  }

  BatchListState copyWith({
    Status? status,
    List<Batch>? batches,
    String? searchQuery,
    BatchStockFilter? stockFilter,
    String? categoryFilterKey,
    Map<String, String>? customSupplyNamesById,
    bool clearCategoryFilter = false,
    String? message,
  }) {
    return BatchListState(
      status: status ?? this.status,
      batches: batches ?? this.batches,
      searchQuery: searchQuery ?? this.searchQuery,
      stockFilter: stockFilter ?? this.stockFilter,
      categoryFilterKey: clearCategoryFilter
          ? null
          : categoryFilterKey ?? this.categoryFilterKey,
      customSupplyNamesById:
          customSupplyNamesById ?? this.customSupplyNamesById,
      message: message ?? this.message,
    );
  }

  static String _categoryLabel(
    Batch batch,
    Map<String, String> customSupplyNamesById,
  ) {
    final mappedName = customSupplyNamesById[batch.customSupplyId]?.trim();
    if (mappedName != null && mappedName.isNotEmpty) return mappedName;

    final name = batch.customSupplyName?.trim();
    if (name != null && name.isNotEmpty) return name;

    final code = batch.code.trim();
    if (code.isNotEmpty) return code;

    return 'Unnamed supply';
  }
}

class BatchCategoryOption {
  const BatchCategoryOption({required this.key, required this.label});

  final String key;
  final String label;
}
