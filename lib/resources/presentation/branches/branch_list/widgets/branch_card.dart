import 'package:flutter/material.dart';
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/presentation/branches/branch_list/widgets/branch_image.dart';

const _card = Color(0xFF151C2A);
const _textPrimary = Color(0xFFEEF2F7);
const _textSecondary = Color(0xFF8899AA);
const _border = Color(0xFF1E2D40);

class BranchCard extends StatelessWidget {
  const BranchCard({super.key, required this.branch});

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border, width: 1),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BranchImage(imageUrl: branch.imageUrl, status: branch.status),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branch.name,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: _textSecondary,
                      size: 13,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        branch.fullAddress,
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}