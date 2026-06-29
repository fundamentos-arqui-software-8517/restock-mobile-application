import 'package:flutter/material.dart';
import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/shared/presentation/widgets/network_aware_image.dart';

class CustomSupplySummaryContent extends StatelessWidget {
  const CustomSupplySummaryContent({super.key, required this.supply});

  final CustomSupply supply;

  static const _ink = Color(0xFF0D1B2A);
  static const _muted = Color(0xFF5A6472);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: const Color(0xFFEFF3F6),
              child: NetworkAwareImage(
                imageUrl: supply.pictureUrl,
                fit: BoxFit.cover,
                placeholder: const Icon(
                  Icons.inventory_2_outlined,
                  color: Color(0xFF9AA5B4),
                  size: 54,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          supply.name,
          style: const TextStyle(
            color: _ink,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _Badge(text: supply.category),
            if (supply.supply.isPerishable) const _Badge(text: 'Perishable'),
          ],
        ),
        const SizedBox(height: 22),
        _InfoSection(
          title: 'Base Supply',
          children: [
            _InfoRow(label: 'Name', value: supply.supply.name),
            _InfoRow(label: 'Description', value: supply.supply.description),
          ],
        ),
        const SizedBox(height: 14),
        _InfoSection(
          title: 'Inventory Rules',
          children: [
            _InfoRow(
              label: 'Minimum stock',
              value: _number(supply.minimumStock),
            ),
            _InfoRow(
              label: 'Maximum stock',
              value: _number(supply.maximumStock),
            ),
            _InfoRow(label: 'Unit', value: supply.unitMeasurement),
          ],
        ),
        const SizedBox(height: 14),
        _InfoSection(
          title: 'Pricing',
          children: [
            _InfoRow(
              label: 'Unit price',
              value:
              '${supply.unitPriceAmount} ${supply.unitPriceCurrencyCode}',
            ),
          ],
        ),
        const SizedBox(height: 14),
        _InfoSection(
          title: 'Notes',
          children: [
            Text(
              supply.description.isEmpty
                  ? 'No description'
                  : supply.description,
              style: const TextStyle(color: _muted, fontSize: 14, height: 1.45),
            ),
          ],
        ),
      ],
    );
  }

  String _number(double value) {
    final text = value.toStringAsFixed(2);
    return text.endsWith('.00') ? text.substring(0, text.length - 3) : text;
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5EE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF2D6A4F),
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE1E6EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF5A6472),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 116,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF5A6472),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(
                color: Color(0xFF0D1B2A),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
