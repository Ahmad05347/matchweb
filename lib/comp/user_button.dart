import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isTrue;
  final String text;
  final Color color;

  const UserButton({
    super.key,
    required this.onTap,
    required this.isTrue,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
