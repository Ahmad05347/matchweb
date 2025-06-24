import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:match_web_app/comp/my_button.dart';
import 'package:animate_do/animate_do.dart';
import 'package:match_web_app/profile/profile_setup_page.dart'; // Make sure to add this package

class FirstComp extends StatelessWidget {
  const FirstComp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      width: double.infinity,
      height: 420,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFDF3F1), Color(0xFFE0C7C2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeInLeft(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Journey to Love Starts Here",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    color: Color(0xFF573746),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Discover meaningful connections and build a future with someone special.",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Color(0xFF573746),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "We believe in more than just matches; we believe in finding your perfect forever.",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Color(0xFF573746),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                MyButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProfileSetupScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          FadeInRight(
            child: Container(
              width: 500,
              height: 500,
              color: Colors.transparent,
              child: Center(
                child: Lottie.asset(
                  'assets/lottie/Animation - 1749782796386.json',
                  width: 500,
                  height: 500,
                  repeat: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
