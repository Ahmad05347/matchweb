import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:match_web_app/comp/common_comps.dart';
import 'package:match_web_app/comp/why_mishkat_container_comp.dart';

class WhyMishkat extends StatelessWidget {
  const WhyMishkat({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        FadeInDown(child: commonText("Why Mishkat?")),
        const SizedBox(height: 40),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: [
            ZoomIn(child: WhyMishkatContainerComp(text: "Complete Privacy")),
            ZoomIn(child: WhyMishkatContainerComp(text: "Mindful MatchMaking")),
            ZoomIn(
              child: WhyMishkatContainerComp(text: "Compatibility Scores"),
            ),
            ZoomIn(child: WhyMishkatContainerComp(text: "ScreenShot Blocking")),
            ZoomIn(
              child: WhyMishkatContainerComp(text: "Selfie & ID Verification"),
            ),
            ZoomIn(child: WhyMishkatContainerComp(text: "Search Filters")),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
