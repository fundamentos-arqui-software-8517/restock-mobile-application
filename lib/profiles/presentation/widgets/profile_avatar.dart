import 'package:flutter/material.dart';
import 'package:restock/shared/presentation/widgets/network_aware_image.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({this.imageUrl, this.onTap});

  final String? imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: const Color(0xFF2A3550),
        child: ClipOval(
          child: NetworkAwareImage(
            imageUrl: imageUrl ?? '',
            width: 40,
            height: 40,
            placeholder: const Icon(
              Icons.person_outline,
              color: Color(0xFF8899AA),
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}