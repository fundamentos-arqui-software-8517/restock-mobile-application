import 'package:flutter/material.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_event.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_state.dart';

class BatchFilterRow extends StatelessWidget {
  const BatchFilterRow({
    super.key,
    required this.stockFilter,
    required this.categoryLabel,
    required this.categoryOptions,
    required this.selectedCategoryKey,
    required this.onStockFilterChanged,
    required this.onCategoryFilterChanged,
  });

  final BatchStockFilter stockFilter;
  final String categoryLabel;
  final List<BatchCategoryOption> categoryOptions;
  final String? selectedCategoryKey;
  final ValueChanged<BatchStockFilter> onStockFilterChanged;
  final ValueChanged<String?> onCategoryFilterChanged;

  static const _allCategoriesKey = '__all_categories__';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FilterButton(
            label: categoryLabel,
            icon: Icons.keyboard_arrow_down,
            onTap: () => _showCategoryFilterSheet(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _FilterButton(
            label: _stockFilterLabel(stockFilter),
            icon: Icons.filter_list,
            onTap: () => _showStockFilterSheet(context),
          ),
        ),
      ],
    );
  }

  Future<void> _showCategoryFilterSheet(BuildContext context) async {
    final selectedCategory = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => _CategoryFilterSheet(
        selectedCategoryKey: selectedCategoryKey,
        options: categoryOptions,
      ),
    );

    if (selectedCategory == null) return;
    onCategoryFilterChanged(
      selectedCategory == _allCategoriesKey ? null : selectedCategory,
    );
  }

  Future<void> _showStockFilterSheet(BuildContext context) async {
    final selectedFilter = await showModalBottomSheet<BatchStockFilter>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => _StockFilterSheet(selectedFilter: stockFilter),
    );

    if (selectedFilter == null) return;
    onStockFilterChanged(selectedFilter);
  }

  String _stockFilterLabel(BatchStockFilter filter) {
    return switch (filter) {
      BatchStockFilter.any => 'Stock Level',
      BatchStockFilter.low => 'Low Stock',
      BatchStockFilter.available => 'Available',
    };
  }
}

class _CategoryFilterSheet extends StatelessWidget {
  const _CategoryFilterSheet({
    required this.selectedCategoryKey,
    required this.options,
  });

  final String? selectedCategoryKey;
  final List<BatchCategoryOption> options;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD0D2D8),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 18),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'CATEGORIES',
                style: TextStyle(
                  color: Color(0xFF5A6472),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _CategoryFilterTile(
              label: 'All Categories',
              categoryKey: BatchFilterRow._allCategoriesKey,
              selectedCategoryKey: selectedCategoryKey,
            ),
            ...options.map(
              (option) => _CategoryFilterTile(
                label: option.label,
                categoryKey: option.key,
                selectedCategoryKey: selectedCategoryKey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryFilterTile extends StatelessWidget {
  const _CategoryFilterTile({
    required this.label,
    required this.categoryKey,
    required this.selectedCategoryKey,
  });

  final String label;
  final String categoryKey;
  final String? selectedCategoryKey;

  @override
  Widget build(BuildContext context) {
    final isSelected = categoryKey == BatchFilterRow._allCategoriesKey
        ? selectedCategoryKey == null
        : categoryKey == selectedCategoryKey;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.of(context).pop(categoryKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5EE) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFB7E2D1)
                : const Color(0xFFE1E6EC),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFD8F1E7)
                    : const Color(0xFFF3F5F7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isSelected ? Icons.check_rounded : Icons.inventory_2_outlined,
                color: isSelected
                    ? const Color(0xFF1B5E45)
                    : const Color(0xFF6B7280),
                size: 19,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF171A22),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockFilterSheet extends StatelessWidget {
  const _StockFilterSheet({required this.selectedFilter});

  final BatchStockFilter selectedFilter;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD0D2D8),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 18),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'STOCK LEVEL',
                style: TextStyle(
                  color: Color(0xFF5A6472),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _StockFilterTile(
              label: 'Stock Level: Any',
              description: 'Show every batch in this branch',
              filter: BatchStockFilter.any,
              selectedFilter: selectedFilter,
            ),
            _StockFilterTile(
              label: 'Low Stock',
              description: 'Only batches under their minimum stock',
              filter: BatchStockFilter.low,
              selectedFilter: selectedFilter,
            ),
            _StockFilterTile(
              label: 'Available Stock',
              description: 'Only batches with stock available',
              filter: BatchStockFilter.available,
              selectedFilter: selectedFilter,
            ),
          ],
        ),
      ),
    );
  }
}

class _StockFilterTile extends StatelessWidget {
  const _StockFilterTile({
    required this.label,
    required this.description,
    required this.filter,
    required this.selectedFilter,
  });

  final String label;
  final String description;
  final BatchStockFilter filter;
  final BatchStockFilter selectedFilter;

  @override
  Widget build(BuildContext context) {
    final isSelected = filter == selectedFilter;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.of(context).pop(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5EE) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFB7E2D1)
                : const Color(0xFFE1E6EC),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFD8F1E7)
                    : const Color(0xFFF3F5F7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isSelected ? Icons.check_rounded : Icons.filter_list,
                color: isSelected
                    ? const Color(0xFF1B5E45)
                    : const Color(0xFF6B7280),
                size: 19,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF171A22),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFD7DCE3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF424854),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(icon, color: const Color(0xFF6B7280), size: 20),
          ],
        ),
      ),
    );
  }
}
