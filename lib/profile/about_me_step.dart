import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AboutMeStep extends StatefulWidget {
  const AboutMeStep({super.key});

  @override
  State<AboutMeStep> createState() => _AboutMeStepState();
}

class _AboutMeStepState extends State<AboutMeStep>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final List<String> personalityTraits = [
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
  final Set<String> selectedTraits = {};

  final List<String> kidsOptions = ['Yes', 'No', 'Maybe'];
  String? wantKids;

  final TextEditingController funFactController = TextEditingController();
  final TextEditingController idealWeekendController = TextEditingController();
  final TextEditingController travelDestinationController =
      TextEditingController();

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
    'Doesn\'t respect personal boundaries',
    'Prefer not to say',
    'Other',
  ];
  final Set<String> selectedDealbreakers = {};

  void _saveData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final data = {
        "about_me": {
          'top_traits': selectedTraits.toList(),
          'want_kids': wantKids,
          'fun_fact': funFactController.text.trim(),
          'ideal_weekend': idealWeekendController.text.trim(),
          'dream_travel_destination': travelDestinationController.text.trim(),
          'dealbreakers': selectedDealbreakers.toList(),
        },
      };
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(data, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Information saved successfully!')),
      );
    } catch (e) {
      debugPrint('Error saving data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save information.')),
      );
    }
  }

  Widget _buildMultiChipField(
    String label,
    List<String> options,
    Set<String> selectedSet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((option) {
            final isSelected = selectedSet.contains(option);
            return FilterChip(
              label: Text(
                option,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => setState(() {
                if (isSelected) {
                  selectedSet.remove(option);
                } else {
                  selectedSet.add(option);
                }
              }),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: GoogleFonts.poppins(fontSize: 15),
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
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    String? selectedValue,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Me',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                _buildMultiChipField(
                  'Top 3 Personality Traits',
                  personalityTraits,
                  selectedTraits,
                ),
                _buildDropdown(
                  "Do you want kids?",
                  kidsOptions,
                  wantKids,
                  (val) => setState(() => wantKids = val),
                ),
                _buildTextField(
                  "A random fun fact about me",
                  funFactController,
                ),
                _buildTextField(
                  "My ideal weekend looks like",
                  idealWeekendController,
                ),
                _buildTextField(
                  "Dream Travel Destination",
                  travelDestinationController,
                ),
                _buildMultiChipField(
                  "Dealbreakers",
                  dealbreakers,
                  selectedDealbreakers,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8f5a56),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Save",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
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
    );
  }
}
