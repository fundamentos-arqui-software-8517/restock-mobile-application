import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectField extends StatelessWidget {
  const SelectField({super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.icon,
    this.itemLabel,
    this.enabled = true,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final IconData? icon;
  final String Function(String value)? itemLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Color(0xFF5A6472),
      ),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF5A6472),
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
        ),
        hintText: label,
        hintStyle: const TextStyle(
          color: Color(0xFF9AA5B4),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: icon == null
            ? null
            : Container(
          width: 42,
          height: 42,
          margin: const EdgeInsets.fromLTRB(10, 8, 8, 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5EE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF2D6A4F), size: 20),
        ),
        filled: true,
        fillColor: enabled ? Colors.white : const Color(0xFFF0F0F0),
        contentPadding: EdgeInsets.fromLTRB(icon == null ? 16 : 0, 14, 12, 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDE1E7), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2D6A4F), width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDE1E7), width: 1.2),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            itemLabel?.call(item) ?? item,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF0D1B2A),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}
