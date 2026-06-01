import 'package:flutter/material.dart';

class RestockTextField extends StatelessWidget {
  const RestockTextField({
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(
        color: Color(0xFF0D1B2A),
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF9AA5B4),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDE1E7), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2D6A4F), width: 1.5),
        ),
      ),
    );
  }
}