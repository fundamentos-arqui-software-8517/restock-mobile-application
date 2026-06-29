import 'package:flutter/material.dart';

class BatchTextField extends StatelessWidget {
  const BatchTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.enabled,
    required this.errorText,
    this.keyboardType,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;
  final String? errorText;
  final TextInputType? keyboardType;
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
        style: const TextStyle(
          color: Color(0xFF171A22),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: const TextStyle(
            color: Color(0xFF7A808A),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          border: _border(const Color(0xFFC9CED8)),
          enabledBorder: _border(const Color(0xFFC9CED8)),
          disabledBorder: _border(const Color(0xFFE1E5EC)),
          focusedBorder: _border(const Color(0xFF007A4D), width: 1.4),
          errorBorder: _border(Colors.redAccent),
          focusedErrorBorder: _border(Colors.redAccent, width: 1.4),
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
