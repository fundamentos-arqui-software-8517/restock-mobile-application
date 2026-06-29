import 'package:flutter/material.dart';

class BatchActionBar extends StatelessWidget {
  const BatchActionBar({
    super.key,
    this.onTransfer,
    this.onCustomSupplies,
    this.onAddBatch,
  });

  final VoidCallback? onTransfer;
  final VoidCallback? onCustomSupplies;
  final VoidCallback? onAddBatch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.swap_horiz,
            label: 'Transfer\nBatch Stock',
            onPressed: onTransfer,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: Icons.inventory_2_outlined,
            label: 'Custom\nSupplies',
            onPressed: onCustomSupplies,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: Icons.add,
            label: 'Add\nBatch',
            isPrimary: true,
            onPressed: onAddBatch,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isPrimary
        ? const Color(0xFF007A4D)
        : const Color(0xFFF2F2F4);
    final foregroundColor = isPrimary ? Colors.white : const Color(0xFF171A22);

    return SizedBox(
      height: 68,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: foregroundColor, size: 22),
        label: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: foregroundColor,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isPrimary
                  ? const Color(0xFF007A4D)
                  : const Color(0xFFD0D2D8),
            ),
          ),
        ),
      ),
    );
  }
}
