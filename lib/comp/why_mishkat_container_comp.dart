import 'package:flutter/material.dart';
import 'package:match_web_app/comp/common_comps.dart';

class WhyMishkatContainerComp extends StatelessWidget {
  final String text;
  const WhyMishkatContainerComp({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 330,
      child: Column(
        children: [
          SizedBox(width: 150, height: 180, child: Placeholder()),
          SizedBox(height: 10),
          secondText(text),
          SizedBox(height: 10),
          thirdText(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. _ no public browsing",
          ),
        ],
      ),
    );
  }
}
