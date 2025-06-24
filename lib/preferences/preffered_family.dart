import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrefferedFamily extends StatefulWidget {
  const PrefferedFamily({super.key});

  @override
  State<PrefferedFamily> createState() => _PrefferedFamilyState();
}

class _PrefferedFamilyState extends State<PrefferedFamily>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  String? maritalStatus;
  String? acceptKids;
  String? familyType;
  String? housing;
  String? relocate;
  String? marriageTimeline;
  String? familyInvolvement;

  final List<String> maritalStatusOptions = [
    'Single',
    'Divorced',
    'Widowed',
    'Separated',
  ];

  final List<String> yesNoMaybeOptions = ['Yes', 'No', 'Maybe'];

  final List<String> familyTypeOptions = ['Nuclear', 'Joint', 'Living Alone'];

  final List<String> housingOptions = [
    'Own house',
    'Renting',
    'With Family',
    'Alone',
  ];

  final List<String> marriageTimelineOptions = [
    'As soon as possible',
    'Within a year',
    '1–2 years',
    'No timeline',
  ];

  final List<String> involvementOptions = [
    'Highly involved',
    'Somewhat involved',
    'Minimal involvement',
    'Not involved',
    'Open to discussion',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _scale = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildChipGroup(
    String title,
    List<String> options,
    String? selected,
    void Function(String) onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((option) {
            final isSelected = selected == option;
            return ChoiceChip(
              label: Text(
                option,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onSelected(option),
              backgroundColor: const Color(0xFFeee9e8),
              selectedColor: const Color(0xFF8f5a56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Future<void> _saveToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'preferredFamily': {
          'maritalStatus': maritalStatus,
          'acceptPartnerWithKids': acceptKids,
          'familyType': familyType,
          'housingSituation': housing,
          'willingToRelocate': relocate,
          'marriageTimeline': marriageTimeline,
          'familyInvolvementLevel': familyInvolvement,
        },
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Information saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving information: $e')));
    }
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
                      'Family & Lifestyle Preferences',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildChipGroup(
                      'Preferred Marital Status',
                      maritalStatusOptions,
                      maritalStatus,
                      (val) => setState(() => maritalStatus = val),
                    ),
                    _buildChipGroup(
                      'Willing to Accept Partner with Kids?',
                      yesNoMaybeOptions,
                      acceptKids,
                      (val) => setState(() => acceptKids = val),
                    ),
                    _buildChipGroup(
                      'Preferred Family Type',
                      familyTypeOptions,
                      familyType,
                      (val) => setState(() => familyType = val),
                    ),
                    _buildChipGroup(
                      'Housing Situation Preference',
                      housingOptions,
                      housing,
                      (val) => setState(() => housing = val),
                    ),
                    _buildChipGroup(
                      'Willing to Relocate',
                      yesNoMaybeOptions,
                      relocate,
                      (val) => setState(() => relocate = val),
                    ),
                    _buildChipGroup(
                      'Timeline for Marriage',
                      marriageTimelineOptions,
                      marriageTimeline,
                      (val) => setState(() => marriageTimeline = val),
                    ),
                    _buildChipGroup(
                      'Preferred Family Involvement Level',
                      involvementOptions,
                      familyInvolvement,
                      (val) => setState(() => familyInvolvement = val),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _saveToFirebase,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8f5a56),
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
}
