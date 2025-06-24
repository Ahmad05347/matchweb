import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isName;
  final bool enabled;
  final bool isObscure;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.label,
    required this.isName,
    this.enabled = true,
    this.isObscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: isObscure,
      style: GoogleFonts.inter(
        fontSize: 15,
        color: enabled ? Colors.black87 : Colors.black54,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
        isDense: true,
        filled: !enabled,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF6B3F4D), width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
