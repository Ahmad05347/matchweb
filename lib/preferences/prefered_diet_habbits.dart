import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreferedDietAndHabbits extends StatefulWidget {
  const PreferedDietAndHabbits({super.key});

  @override
  State<PreferedDietAndHabbits> createState() => _PreferedDietAndHabbitsState();
}

class _PreferedDietAndHabbitsState extends State<PreferedDietAndHabbits>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;
  bool isFormValid = false;

  final List<String> preferredDiets = [
    'Vegetarian',
    'Non-Vegetarian',
    'Vegan',
    'Halal Only',
    'No Preference',
    'Other',
  ];

  final List<String> smokingOptions = ['Yes', 'No', 'Prefer not to say'];
  final List<String> petsOptions = ['Yes', 'No', 'Doesn’t matter'];
  final List<String> childrenOptions = ['Yes', 'No', 'Maybe'];

  final List<String> topTraits = [
    'Ambitious',
    'Calm',
    'Caring',
    'Cheerful',
    'Confident',
    'Creative',
    'Dependable',
    'Empathetic',
    'Energetic',
    'Family-oriented',
    'Funny / Humorous',
    'Honest',
    'Independent',
    'Introverted',
    'Kind',
    'Loyal',
    'Modest',
    'Outgoing',
    'Patient',
    'Practical',
    'Religious',
    'Responsible',
    'Romantic',
    'Smart / Intelligent',
    'Social',
    'Spiritual',
    'Talkative',
    'Thoughtful',
    'Understanding',
    'Wise',
  ];

  final List<String> dealbreakers = [
    'Smoking',
    'Drinking alcohol',
    'Not praying / not religious',
    'Different sect or beliefs',
    'Disrespectful behavior',
    'Dishonesty',
    'Poor communication',
    'Lack of ambition',
    'No family involvement',
    'Wants to live abroad permanently',
    'Not willing to relocate',
    'Already married / in another relationship',
    'Different cultural values',
    'Doesn\'t want children',
    'Too focused on looks or wealth',
    'No career or income stability',
    'Controlling or possessive behavior',
    'Doesn’t respect personal boundaries',
    'Prefer not to say',
    'Other',
  ];

  String? selectedDiet;
  String? smokingAcceptable;
  String? mustLikePets;
  String? wantsChildren;
  String? otherDietText = '';
  String? otherDealbreakerText = '';

  final Set<String> selectedTraits = {};
  final Set<String> selectedDealbreakers = {};

  @override
  void initState() {
    super.initState();
    isFormValid = _checkFormValidity();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _scale = Tween<double>(
      begin: 0.95,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));
    _controller.forward();
  }

  bool _checkFormValidity() {
    return selectedTraits.isNotEmpty &&
        selectedDealbreakers.isNotEmpty &&
        selectedDiet != null;
  }

  Future<void> _saveToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'preferredDietAndHabits': {
          'preferredDiet': selectedDiet,
          'otherDiet': selectedDiet == 'Other' ? otherDietText : null,
          'smokingAcceptable': smokingAcceptable,
          'mustLikeOrAcceptPets': mustLikePets,
          'preferredTopPersonalityTraits': selectedTraits.toList(),
          'wantsPartnerWithChildren': wantsChildren,
          'dealbreakers': selectedDealbreakers.toList(),
          'otherDealbreaker': selectedDealbreakers.contains('Other')
              ? otherDealbreakerText
              : null,
        },
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Information saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    String? value,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFFb58f86),
                width: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
        if (value == 'Other')
          TextFormField(
            onChanged: (val) {
              if (label.contains('Diet')) {
                otherDietText = val;
              } else {
                otherDealbreakerText = val;
              }
            },
            decoration: InputDecoration(
              hintText: "Please specify",
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFFb58f86),
                  width: 1.5,
                ),
              ),
            ),
          ),
        if (value == 'Other') const SizedBox(height: 25),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => Opacity(
            opacity: _opacity.value,
            child: Transform.scale(
              scale: _scale.value,
              child: Container(
                width: size.width * 0.7,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diet & Habits Preferences',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildDropdown(
                      "Preferred Diet",
                      preferredDiets,
                      selectedDiet,
                      (val) => setState(() => selectedDiet = val),
                    ),
                    _buildDropdown(
                      "Smoking Acceptable?",
                      smokingOptions,
                      smokingAcceptable,
                      (val) => setState(() => smokingAcceptable = val),
                    ),
                    _buildDropdown(
                      "Must Like or Accept Pets?",
                      petsOptions,
                      mustLikePets,
                      (val) => setState(() => mustLikePets = val),
                    ),
                    _buildDropdown(
                      "Want Partner Who Wants Children?",
                      childrenOptions,
                      wantsChildren,
                      (val) => setState(() => wantsChildren = val),
                    ),
                    _buildLimitedChips(
                      title: "Preferred Top Personality Traits",
                      options: topTraits,
                      selectedSet: selectedTraits,
                      maxSelection: 5,
                    ),

                    _buildLimitedChips(
                      title: "Dealbreakers in a Partner",
                      options: dealbreakers,
                      selectedSet: selectedDealbreakers,
                      maxSelection: 7,
                      allowOther: true,
                    ),

                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: isFormValid ? _saveToFirebase : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFormValid
                              ? const Color(0xFF8f5a56)
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "Save",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLimitedChips({
    required String title,
    required List<String> options,
    required Set<String> selectedSet,
    required int maxSelection,
    bool allowOther = false,
    void Function()? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            Text(
              '(${selectedSet.length}/$maxSelection selected)',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((option) {
            final isSelected = selectedSet.contains(option);
            return ChoiceChip(
              label: Text(
                option,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  if (isSelected) {
                    selectedSet.remove(option);
                  } else {
                    if (selectedSet.length >= maxSelection) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "You can select up to $maxSelection options.",
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else {
                      selectedSet.add(option);
                    }
                  }
                  if (onChanged != null) onChanged();
                  isFormValid = _checkFormValidity();
                });
              },
              backgroundColor: const Color(0xFFeee9e8),
              selectedColor: const Color(0xFF8f5a56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }).toList(),
        ),
        if (allowOther && selectedSet.contains('Other')) ...[
          const SizedBox(height: 10),
          TextFormField(
            onChanged: (val) {
              otherDealbreakerText = val;
              if (onChanged != null) onChanged();
            },
            decoration: InputDecoration(
              hintText: "Please specify",
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFFb58f86),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 25),
      ],
    );
  }
}
