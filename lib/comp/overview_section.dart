import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:match_web_app/comp/common_comps.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: const BoxDecoration(color: Color(0xFFe0c7c2)),
      child: FadeInUp(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                commonText("Mishkat"),
                const SizedBox(height: 10),
                Placeholder(
                  fallbackHeight: 60,
                  fallbackWidth: 60,
                  child: Text(
                    "Logo",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                /* Lottie.asset(
                  'assets/lottie/logo_anim.json',
                  width: 60,
                  height: 60,
                  repeat: true,
                ), */
                const SizedBox(height: 10),
                Text(
                  "All Rights Reserved © 2024",
                  style: GoogleFonts.poppins(fontSize: 10),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                secondText("Company"),
                const SizedBox(height: 7),
                overviewText("About Us"),
                overviewText("Viqar's Blog"),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                secondText("Product"),
                const SizedBox(height: 7),
                overviewText("Sign Up"),
                overviewText("How it works"),
                overviewText("Success Stories"),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                secondText("Help & Support"),
                const SizedBox(height: 7),
                overviewText("Contact Us"),
                overviewText("Report Misconduct"),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                secondText("Legal"),
                const SizedBox(height: 7),
                overviewText("Terms"),
                overviewText("Privacy Policy"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
