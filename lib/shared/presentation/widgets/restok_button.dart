import 'package:flutter/material.dart';

/// A reusable button widget for the Restock application, with built-in loading state and customizable text and height.
class RestockButton extends StatelessWidget {
  const RestockButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.height = 54,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDisabled = !enabled || isLoading;

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDisabled
              ? const Color(0xFF1B4332).withValues(alpha: 0.4)
              : const Color(0xFF1B4332),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: isDisabled
                        ? Colors.white.withValues(alpha: 0.6)
                        : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }
}