import 'package:flutter/material.dart';
import 'package:restock/shared/presentation/utils/ui/theme.dart';
import 'package:restock/shared/presentation/widgets/network_aware_image.dart';

/// A widget that displays an image for a branch, along with a status badge indicating whether the branch is active or inactive. The image is loaded from a URL, and if it fails to load, a placeholder icon is shown instead. The status badge is positioned in the top-right corner of the image and changes color based on the branch's status.
class BranchImage extends StatelessWidget {
  const BranchImage({super.key, required this.imageUrl, required this.status});

  final String imageUrl;
  final String status;

  String get _badgeLabel => status.toUpperCase();

  Color get _badgeColor {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color.fromARGB(255, 0, 212, 141);
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
          NetworkAwareImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: Container(
              color: const Color(0xFF1E2D40),
              child: const Icon(Icons.business, color: textSecondary, size: 48),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
