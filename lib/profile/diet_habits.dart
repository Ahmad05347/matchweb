import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DietHabits extends StatefulWidget {
  const DietHabits({super.key});

  @override
  State<DietHabits> createState() => _DietHabitsState();
}

class _DietHabitsState extends State<DietHabits>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  String? selectedDiet;
  String? selectedSmoke;
  String? selectedAlcohol;
  String? selectedPets;

  final TextEditingController otherDietController = TextEditingController();
  final TextEditingController otherPetsController = TextEditingController();

  final List<String> dietOptions = [
    'Vegetarian',
    'Non-Vegetarian',
    'Vegan',
    'Halal Only',
    'No Preference',
    'Other',
  ];

  final List<String> smokeOptions = ['Yes', 'No', 'Prefer not to say'];
  final List<String> alcoholOptions = ['Yes', 'No', 'Prefer not to say'];
  final List<String> petOptions = [
    'No Pets',
    'Has Cats',
    'Has Dogs',
    'Other',
    'Likes Pets',
    'Doesn’t Like Pets',
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
    otherDietController.dispose();
    otherPetsController.dispose();
    super.dispose();
  }

  Future<void> _saveToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final dietToSave = selectedDiet == 'Other'
        ? otherDietController.text.trim()
        : selectedDiet;
    final petsToSave = selectedPets == 'Other'
        ? otherPetsController.text.trim()
        : selectedPets;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'dietHabits': {
          'diet': dietToSave,
          'smoke': selectedSmoke,
          'alcohol': selectedAlcohol,
          'pets': petsToSave,
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

  Widget _buildChipGroup(
    String title,
    List<String> options,
    String? selected,
    void Function(String) onSelected, {
    TextEditingController? otherController,
  }) {
    final isOtherSelected = selected == 'Other';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
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
        if (isOtherSelected && otherController != null) ...[
          const SizedBox(height: 12),
          TextField(
            controller: otherController,
            decoration: InputDecoration(
              hintText: 'Please specify...',
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
        const SizedBox(height: 30),
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
                      'Diet & Lifestyle Preferences',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildChipGroup(
                      'Diet',
                      dietOptions,
                      selectedDiet,
                      (val) => setState(() => selectedDiet = val),
                      otherController: otherDietController,
                    ),
                    _buildChipGroup(
                      'Smoke',
                      smokeOptions,
                      selectedSmoke,
                      (val) => setState(() => selectedSmoke = val),
                    ),
                    _buildChipGroup(
                      'Drinks Alcohol',
                      alcoholOptions,
                      selectedAlcohol,
                      (val) => setState(() => selectedAlcohol = val),
                    ),
                    _buildChipGroup(
                      'Pets',
                      petOptions,
                      selectedPets,
                      (val) => setState(() => selectedPets = val),
                      otherController: otherPetsController,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
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
                        onPressed: _saveToFirebase,
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
