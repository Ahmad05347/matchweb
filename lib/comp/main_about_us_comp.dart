import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:match_web_app/comp/common_comps.dart';
import 'package:animate_do/animate_do.dart';

class MainAboutUsComp extends StatelessWidget {
  const MainAboutUsComp({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          MediaQuery.of(context).size.height *
          0.5, // Make it occupy 80% of screen height
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
          child: FadeInUp(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Heading
                commonText("About Us"),
                const SizedBox(height: 10),

                // Content Row
                SizedBox(
                  width: 1200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text section
                      Expanded(
                        child: secondText(
                          "We are a team of passionate individuals dedicated to creating meaningful connections. Our mission is to provide a safe and engaging platform for people to meet, interact, and build relationships. With a focus on privacy, security, and user experience, we strive to make online matchmaking a positive and enjoyable experience for everyone.",
                        ),
                      ),
                      const SizedBox(width: 40),

                      // Animation section
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: Lottie.asset(
                          'assets/lottie/Animation - 1749783873322.json',
                          repeat: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
