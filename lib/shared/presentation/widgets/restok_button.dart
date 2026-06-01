import 'package:flutter/material.dart';

class RestockButton extends StatelessWidget {
  const RestockButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.height = 54,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isLoading
              ? const Color(0xFF1B4332).withValues(alpha: 0.6)
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
                  style: const TextStyle(
                    color: Colors.white,
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