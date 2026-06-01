import 'package:flutter/material.dart';
import 'package:restock/shared/presentation/utils/ui/theme.dart';


class BranchImage extends StatelessWidget {
  const BranchImage({
    super.key,
    required this.imageUrl,
    required this.status,
  });

  final String imageUrl;
  final String status;

  String get _badgeLabel => status.toUpperCase();

  Color get _badgeColor {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF4ECCA3);
      case 'inactive':
        return const Color(0xFFE24B4A);
      default:
        return textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              color: const Color(0xFF1E2D40),
              child: const Icon(
                Icons.business,
                color: textSecondary,
                size: 48,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0x66000000)],
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _badgeColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _badgeLabel,
                style: const TextStyle(
                  color: Color(0xFF0F1520),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}