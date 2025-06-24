import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Appearances extends StatefulWidget {
  const Appearances({super.key});

  @override
  State<Appearances> createState() => _AppearancesState();
}

class _AppearancesState extends State<Appearances>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;
  final TextEditingController _mentalDisabilityController =
      TextEditingController();
  final TextEditingController _physicalDisabilityController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add this utility method in the class
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return SizedBox(
      width: 400, // Match the design
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        style: GoogleFonts.poppins(fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
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
            borderSide: const BorderSide(color: Color(0xFFb58f86), width: 1.5),
          ),
        ),
      ),
    );
  }

  final Map<String, List<String>> appearanceData = {
    'Height (ft)': [
      "4'5",
      "4'6",
      "4'7",
      "4'8",
      "4'9",
      "4'10",
      "4'11",
      "5'0",
      "5'1",
      "5'2",
      "5'3",
      "5'4",
      "5'5",
      "5'6",
      "5'7",
      "5'8",
      "5'9",
      "5'10",
      "5'11",
      "6'0",
      "6'1",
      "6'2",
      "6'3",
      "6'4",
      "6'5",
    ],
    'How would you Briefly describe your body type?': [
      'Slim',
      'Athletic',
      'Average',
      'Plus Size',
      'Prefer not to say',
    ],
    'How would you Briefly describe your skin tone?': [
      'Fair',
      'Medium',
      'Dark',
      'Prefer not to say',
    ],
    'Mental Disabilities': ['Yes', 'No', 'Prefer not to say'],
    'Physical Disabilities': ['Yes', 'No', 'Prefer not to say'],
  };

  final Map<String, String> selectedAppearance = {};
  bool showHijabBeard = false;

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

  void toggleAppearance(String category, String value) {
    setState(() {
      selectedAppearance[category] = value;
    });
  }

  Future<void> saveToFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await docRef.set({
      'appearance': {
        ...selectedAppearance,
        if (_mentalDisabilityController.text.isNotEmpty)
          'Mental Disability Details': _mentalDisabilityController.text,
        if (_physicalDisabilityController.text.isNotEmpty)
          'Physical Disability Details': _physicalDisabilityController.text,
      },
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appearance saved to Firebase!')),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildChips(String category, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((option) {
            final isMultiSelect =
                category == 'How would you Briefly describe your body type?';
            final isSelected = isMultiSelect
                ? (selectedAppearance[category]?.contains(option) ?? false)
                : selectedAppearance[category] == option;

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
                  if (isMultiSelect) {
                    final current =
                        selectedAppearance[category]?.split(', ') ?? [];
                    if (isSelected) {
                      current.remove(option);
                    } else {
                      current.add(option);
                    }
                    selectedAppearance[category] = current.join(', ');
                  } else {
                    selectedAppearance[category] = option;
                  }
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
                      'Your Appearance',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    ...appearanceData.entries.map((entry) {
                      if (entry.key == 'Hijab/Beard Preference' &&
                          !showHijabBeard) {
                        return TextButton(
                          onPressed: () {
                            setState(() => showHijabBeard = true);
                          },
                          child: const Text(
                            'Show optional Hijab/Beard Preference',
                          ),
                        );
                      }
                      if (entry.key == 'Hijab/Beard Preference' &&
                          showHijabBeard == false) {
                        return const SizedBox.shrink();
                      }
                      return buildChips(entry.key, entry.value);
                    }),
                    if (selectedAppearance['Mental Disabilities'] == 'Yes')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: _buildTextField(
                          "If yes, please specify",
                          _mentalDisabilityController,
                        ),
                      ),

                    if (selectedAppearance['Physical Disabilities'] == 'Yes')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: _buildTextField(
                          "If yes, please specify",
                          _physicalDisabilityController,
                        ),
                      ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: saveToFirestore,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8f5a56),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: GoogleFonts.poppins(
                            color: Colors.white,

                            fontWeight: FontWeight.w600,
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
