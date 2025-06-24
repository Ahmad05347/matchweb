import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HobbiesStep extends StatefulWidget {
  const HobbiesStep({super.key});

  @override
  State<HobbiesStep> createState() => _HobbiesStepState();
}

class _HobbiesStepState extends State<HobbiesStep>
    with SingleTickerProviderStateMixin {
  final Set<String> selectedHobbies = {};
  final TextEditingController otherHobbyController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  final List<String> hobbiesOptions = [
    'Reading',
    'Writing / Journaling',
    'Cooking / Baking',
    'Traveling',
    'Watching movies / TV shows',
    'Photography',
    'Gardening',
    'Painting / Drawing / Art',
    'Playing musical instruments',
    'Listening to music',
    'Fitness / Gym / Yoga',
    'Hiking / Outdoor activities',
    'Sports (e.g., cricket, football)',
    'Volunteering / Community work',
    'Gaming',
    'DIY / Crafting',
    'Shopping / Fashion',
    'Learning languages',
    'Technology / Coding',
    'Spending time with family and friends',
    'Meditation / Mindfulness',
    'Prefer not to say',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _scale = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    otherHobbyController.dispose();
    super.dispose();
  }

  Future<void> _saveToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final List<String> hobbies = selectedHobbies.toList();
    if (selectedHobbies.contains('Other') &&
        otherHobbyController.text.trim().isNotEmpty) {
      hobbies.add(otherHobbyController.text.trim());
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'hobbies': hobbies,
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hobbies saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving hobbies: $e')));
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
                      'Select Your Hobbies',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: hobbiesOptions.map((hobby) {
                        final isSelected = selectedHobbies.contains(hobby);
                        return FilterChip(
                          label: Text(
                            hobby,
                            style: GoogleFonts.poppins(
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              if (isSelected) {
                                selectedHobbies.remove(hobby);
                              } else {
                                selectedHobbies.add(hobby);
                              }
                            });
                          },
                          selectedColor: const Color(0xFF8f5a56),
                          backgroundColor: const Color(0xFFeee9e8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      }).toList(),
                    ),
                    if (selectedHobbies.contains('Other')) ...[
                      const SizedBox(height: 20),
                      Text(
                        'Please specify other hobby:',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: otherHobbyController,
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
                    ],
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
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
