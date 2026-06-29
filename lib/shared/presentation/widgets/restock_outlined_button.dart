import 'package:flutter/material.dart';

class RestockOutlinedButton extends StatelessWidget {
  const RestockOutlinedButton({
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
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDisabled
                ? const Color(0xFFC9CED8).withValues(alpha: 0.4)
                : const Color(0xFFC9CED8),
            width: 1.5,
          ),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              color: Color(0xFF7A808A),
              strokeWidth: 2,
            ),
          )
              : Text(
            text,
            style: TextStyle(
              color: isDisabled
                  ? const Color(0xFF7A808A).withValues(alpha: 0.4)
                  : const Color(0xFF7A808A),
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