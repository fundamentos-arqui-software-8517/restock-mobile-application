import 'package:flutter/material.dart';

class BranchStatusToggle extends StatelessWidget {
  const BranchStatusToggle({
    super.key,
    required this.isActive,
    required this.onChanged,
    this.isLoading = false,
  });

  final bool isActive;
  final ValueChanged<bool> onChanged;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Branch Status',
                style: TextStyle(
                  color: Color(0xFF0D1B2A),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Visible to all managers',
                style: TextStyle(color: Color(0xFF888888), fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              if (isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Text(
                  isActive ? 'ON/ACTIVE' : 'OFF/INACTIVE',
                  style: TextStyle(
                    color: isActive
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFF888888),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const SizedBox(width: 8),
              Switch(
                value: isActive,
                onChanged: isLoading ? null : onChanged,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF2E7D32),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFCCCCCC),
              ),
            ],
          ),
        ],
      ),
    );
  }
}