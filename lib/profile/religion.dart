import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Religion extends StatefulWidget {
  const Religion({super.key});

  @override
  State<Religion> createState() => _ReligionState();
}

class _ReligionState extends State<Religion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;
  final TextEditingController otherReligionController = TextEditingController();
  final TextEditingController casteController = TextEditingController();
  final TextEditingController quoteController = TextEditingController();
  final Map<String, String> selectedReligion = {};

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Map<String, List<String>> religionOptions = {
    'Religion': ['Islam', 'Hinduism', 'Christianity', 'Other'],
    'Sect': [
      'Sunni',
      'Shia',
      'Ahl-e-Hadith',
      'Deobandi',
      'Barelvi',
      'Bohra',
      'Ismaili',
      'Prefer not to say',
      'Other',
    ],
    'Religious Practice Level': [
      'Not practicing',
      'Occasionally',
      'Regularly',
      'Very committed',
    ],
    'Do you pray regularly?': ['Yes', 'Sometimes', 'No', 'Prefer not to say'],
    'How important is religion to you': [
      'Very important',
      'Important',
      'Neutral',
      'Not important',
      'Does not matter at all',
    ],
  };

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

  void toggleReligion(String category, String value) {
    setState(() {
      selectedReligion[category] = value;
    });
  }

  Future<void> saveToFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await docRef.set({
      'religion': {
        ...selectedReligion,
        if (selectedReligion['Religion'] == 'Other' &&
            otherReligionController.text.trim().isNotEmpty)
          'Specified Religion': otherReligionController.text.trim(),
        'Caste': casteController.text.trim(),
        'Favourite Surah or Quote': quoteController.text.trim(),
      },
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Religion info saved to Firebase!')),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    casteController.dispose();
    quoteController.dispose();
    otherReligionController.dispose();
    super.dispose();
  }

  Widget _buildChips(String category, List<String> options) {
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
            final isSelected = selectedReligion[category] == option;
            return ChoiceChip(
              label: Text(
                option,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => toggleReligion(category, option),
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

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
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
                      'Religious Information',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...religionOptions.entries.map((e) {
                      final category = e.key;
                      final options = e.value;

                      final widget = _buildChips(category, options);

                      // Show TextField if Religion == Other
                      if (category == 'Religion' &&
                          selectedReligion['Religion'] == 'Other') {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget,
                            _buildTextField(
                              'Please specify your religion',
                              otherReligionController,
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }

                      return widget;
                    }),

                    _buildTextField('Caste (Optional)', casteController),
                    const SizedBox(height: 20),
                    _buildTextField(
                      'Favourite Surah or Quote',
                      quoteController,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 30),
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
