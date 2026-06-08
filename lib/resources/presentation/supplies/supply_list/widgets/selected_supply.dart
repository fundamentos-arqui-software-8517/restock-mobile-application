import 'package:flutter/material.dart';
import 'package:restock/resources/domain/entities/supply.dart';

class SelectedSupply extends StatelessWidget {
  const SelectedSupply({super.key, required this.supply, required this.isPlaceholder});

  final Supply supply;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Text(
      supply.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF0D1B2A),
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class SupplyOption extends StatelessWidget {
  const SupplyOption({super.key, required this.supply});

  final Supply supply;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5EE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: Color(0xFF2D6A4F),
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  supply.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF0D1B2A),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${supply.category}${supply.isPerishable ? ' • Perishable' : ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF7B8794),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
