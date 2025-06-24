import 'package:flutter/material.dart';
import 'package:match_web_app/comp/common_comps.dart';
import 'package:animate_do/animate_do.dart';

class MainHowItWorksComps extends StatelessWidget {
  const MainHowItWorksComps({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      width: double.infinity,
      decoration: BoxDecoration(color: Color(0xFFf7e4de)),
      child: FadeInUp(
        child: Column(
          children: [
            commonText("How It Works"),
            const SizedBox(height: 20),
            SizedBox(
              width: 1000,
              child: Column(
                children: [
                  _stepCard(
                    "1. Sign Up",
                    "Create your profile by providing basic information and preferences.",
                  ),
                  _stepCard(
                    "2. Explore Matches",
                    "Browse through potential matches based on your interests and location.",
                  ),
                  _stepCard(
                    "3. Connect",
                    "Send messages and start conversations.",
                  ),
                  _stepCard("4. Meet Up", "Arrange to meet or keep chatting."),
                  _stepCard(
                    "5. Feedback",
                    "Share your experience to help us improve.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepCard(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF573746)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
                Text(desc),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
