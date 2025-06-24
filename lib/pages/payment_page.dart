import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:match_web_app/comp/main_header.dart';
import 'package:match_web_app/comp/overview_section.dart';
import 'package:match_web_app/comp/payment_plans.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDF6F3), Color(0xFFEFE1DC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const MainHeader(),
              const SizedBox(height: 30),
              Text(
                "Payment Plans & Overview",
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF30232c),
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: const [
                  PaymentPlans(
                    colors: Color(0xFFe0c7c2),
                    text: "Monthly",
                    price: "\$19.99",
                    description: "Ideal for quick connections",
                  ),
                  PaymentPlans(
                    colors: Color(0xFFb58f86),
                    text: "6 Months",
                    price: "\$99.99",
                    description: "Best value for regular users",
                  ),
                  PaymentPlans(
                    colors: Color(0xFF30232c),
                    text: "Yearly",
                    price: "\$179.99",
                    description: "Full access all year round",
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const OverviewSection(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
