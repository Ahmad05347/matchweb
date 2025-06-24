import 'package:flutter/material.dart';
import 'package:match_web_app/comp/first_comp.dart';
import 'package:match_web_app/comp/main_about_us_comp.dart';
import 'package:match_web_app/comp/main_header.dart';
import 'package:match_web_app/comp/main_how_it_works_comps.dart';
import 'package:match_web_app/comp/overview_section.dart';
import 'package:match_web_app/comp/testimonial_section.dart';
import 'package:match_web_app/comp/why_mishkat.dart';
import 'package:match_web_app/widgets/lazy_load_widget.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(
            children: [
              MainHeader(),
              LazyLoadWidget(child: FirstComp()),
              LazyLoadWidget(child: MainAboutUsComp()),
              LazyLoadWidget(child: MainHowItWorksComps()),
              LazyLoadWidget(child: WhyMishkat()),
              LazyLoadWidget(child: TestimonialsSection()),
              LazyLoadWidget(child: OverviewSection()),
            ],
          ),
        ],
      ),
    );
  }
}
