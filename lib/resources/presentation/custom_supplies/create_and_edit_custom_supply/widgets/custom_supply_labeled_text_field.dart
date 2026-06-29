import 'package:flutter/material.dart';

class CustomSupplyLabeledTextField extends StatelessWidget {
  const CustomSupplyLabeledTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.enabled,
    this.keyboardType,
    this.errorText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;
  final TextInputType? keyboardType;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: TextStyle(
          color: enabled ? const Color(0xFF0D1B2A) : const Color(0xFF9AA5B4),
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: const TextStyle(
            color: Color(0xFF5A6472),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
          filled: true,
          fillColor: enabled ? Colors.white : const Color(0xFFF0F0F0),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          enabledBorder: _border(const Color(0xFFDDE1E7), width: 1.2),
          focusedBorder: _border(const Color(0xFF2D6A4F), width: 1.5),
          disabledBorder: _border(const Color(0xFFEEEEEE), width: 1.2),
          errorBorder: _border(const Color(0xFFE24B4A), width: 1.2),
          focusedErrorBorder: _border(const Color(0xFFE24B4A), width: 1.5),
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
