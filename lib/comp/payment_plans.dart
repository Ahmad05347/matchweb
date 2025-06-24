import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentPlans extends StatefulWidget {
  final Color colors;
  final String text;
  final String price;
  final String description;

  const PaymentPlans({
    super.key,
    required this.colors,
    required this.text,
    required this.price,
    required this.description,
  });

  @override
  State<PaymentPlans> createState() => _PaymentPlansState();
}

class _PaymentPlansState extends State<PaymentPlans> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: _hovering
            ? (Matrix4.identity()..scale(1.03))
            : Matrix4.identity(),
        width: 250,
        height: 340,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.colors,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.price,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.85),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: widget.colors,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                'Select Plan',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
