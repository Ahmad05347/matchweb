import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isName;
  final bool enabled;

  const UserTextfield({
    super.key,
    required this.controller,
    required this.label,
    required this.isName,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: enabled ? Colors.black87 : Colors.black54,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
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
            borderSide: const BorderSide(color: Colors.indigo, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
