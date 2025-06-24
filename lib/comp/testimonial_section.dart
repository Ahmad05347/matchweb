import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFFb58f86)),
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          const SizedBox(height: 30),
          FadeInDown(
            child: Text(
              "Testimonials",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
            ),
          ),
          const SizedBox(height: 30),
          FadeInUp(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.arrow_back_ios, color: Colors.white),
                SizedBox(
                  width: 1200,
                  child: Column(
                    children: [
                      Placeholder(
                        fallbackHeight: 150,
                        fallbackWidth: 150,
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                      /*  Lottie.asset(
                        'assets/lottie/testimonials.json',
                        width: 150,
                        repeat: true,
                      ), */
                      const SizedBox(height: 20),
                      Text(
                        "We value the feedback from our users and are proud to share their experiences with our platform. Here are some testimonials from individuals who have found meaningful connections through our service. Their stories inspire us to continue improving and providing a space where everyone can feel connected and valued. We are grateful for their trust and support, and we look forward to hearing more success stories in the future. Thank you for being a part of our community!",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
