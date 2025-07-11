import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:match_web_app/colors/elegant_colors.dart';
import 'package:match_web_app/pages/dashboard.dart';
import 'package:match_web_app/preferences/personal_preferences.dart';
import 'package:match_web_app/preferences/prefered_diet_habbits.dart';
import 'package:match_web_app/preferences/prefered_hobbies.dart';
import 'package:match_web_app/preferences/prefered_interest.dart';
import 'package:match_web_app/preferences/preffered_appearances.dart';
import 'package:match_web_app/preferences/preffered_education.dart';
import 'package:match_web_app/preferences/preffered_family.dart';
import 'package:match_web_app/preferences/preffered_religion.dart';
import 'package:match_web_app/profile/final_step.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PreferencesSetupScreen extends StatefulWidget {
  const PreferencesSetupScreen({super.key});

  @override
  State<PreferencesSetupScreen> createState() => _PreferencesSetupScreenState();
}

class _PreferencesSetupScreenState extends State<PreferencesSetupScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  int get _totalSteps => stepTitles.length;

  final List<String> stepTitles = [
    "Personal Preferences",
    "Preferred Religion",
    "Prefered Education & Career",
    "Prefered Family & Lifestyle",
    "Prefered Appearances",
    "Prefered Diet & Habits",
    "Prefered Hobbies",
    "Prefered Interest's",
    "Finish",
  ];

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to Dashboard when Finish is pressed
      Navigator.push(context, MaterialPageRoute(builder: (_) => Dashboard()));
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildTimeline() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_totalSteps, (index) {
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;

          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min, // ✅ Important
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isCompleted || isCurrent
                        ? const LinearGradient(
                            colors: [Color(0xFF8c595c), Color(0xFF8c595c)],
                          )
                        : const LinearGradient(
                            colors: [Colors.grey, Colors.grey],
                          ),
                  ),
                  child: Center(
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  stepTitles[index],
                  style: TextStyle(
                    fontSize: 12,
                    color: isCurrent
                        ? const Color(0xFF573746)
                        : Colors.black.withOpacity(0.4),
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                if (index < _totalSteps - 1)
                  Flexible(
                    // ✅ Fixes layout error
                    fit: FlexFit.loose,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 8,
                      ),
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isCompleted
                              ? [Color(0xFFb58f86), Color(0xFF573746)]
                              : [Colors.grey[300]!, Colors.grey[300]!],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildTimeline(),

          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                PersonalPreferences(),
                PreferredReligion(),
                PrefferedEducation(),
                PrefferedFamily(),
                PrefferedAppearances(),
                PreferedDietAndHabbits(),
                PreferedHobbies(),
                PreferedInterest(),
                FinalStep(text: "Preferences Setup"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // ✅ Align everything to the right
              children: [
                if (_currentStep > 0)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _CustomNavButton(
                      text: "Back",
                      onTap: _prevStep,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFd4c2be), Color(0xFFa28a87)],
                      ),
                    ),
                  ),
                _CustomNavButton(
                  text: _currentStep == _totalSteps - 1 ? 'Finish' : 'Next',
                  onTap: _nextStep,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFb58f86), Color(0xFF573746)],
                  ),
                ),
              ],
            ),
          ),

          SmoothPageIndicator(
            controller: _pageController,
            count: _totalSteps,
            effect: ExpandingDotsEffect(
              dotColor: ElegantColors.nude,
              activeDotColor: ElegantColors.charcoal,
              dotHeight: 10,
              dotWidth: 10,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _CustomNavButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final LinearGradient gradient;

  const _CustomNavButton({
    required this.text,
    required this.onTap,
    required this.gradient,
  });

  @override
  State<_CustomNavButton> createState() => _CustomNavButtonState();
}

class _CustomNavButtonState extends State<_CustomNavButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 130,
          height: 45,
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(_isPressed ? 10 : 14),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
