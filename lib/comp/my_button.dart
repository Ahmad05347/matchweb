// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatefulWidget {
  final VoidCallback onTap;

  const MyButton({super.key, required this.onTap});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 200,
          height: 45,
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFFe0c7c2)
                : const Color(0xFFf3dfdb),
            borderRadius: BorderRadius.circular(_isPressed ? 10 : 20),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFFe0c7c2).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              "Get Started",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF30232c),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
