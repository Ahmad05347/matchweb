import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogInButton extends StatefulWidget {
  final VoidCallback onTap;

  const LogInButton({super.key, required this.onTap});

  @override
  State<LogInButton> createState() => _LogInButtonState();
}

class _LogInButtonState extends State<LogInButton> {
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
          width: 80,
          height: 35,
          decoration: BoxDecoration(
            color: _isHovered ? Color(0xFFb58f86) : Color(0xFFb58f86),
            borderRadius: BorderRadius.circular(_isPressed ? 8 : 10),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Color(0xFFb58f86).withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              "LogIn",
              style: GoogleFonts.poppins(
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
