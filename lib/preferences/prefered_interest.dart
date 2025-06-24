import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreferedInterest extends StatefulWidget {
  const PreferedInterest({super.key});

  @override
  State<PreferedInterest> createState() => _PreferedInterestState();
}

class _PreferedInterestState extends State<PreferedInterest>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  final List<String> interestOptions = [
    "Reading",
    "Writing / Journaling",
    "Cooking / Baking",
    "Traveling",
    "Watching movies / TV shows",
    "Photography",
    "Gardening",
    "Painting / Drawing / Art",
    "Playing musical instruments",
    "Listening to music",
    "Fitness / Gym / Yoga",
    "Hiking / Outdoor activities",
    "Sports (e.g., cricket, football)",
    "Volunteering / Community work",
    "Gaming",
    "DIY / Crafting",
    "Shopping / Fashion",
    "Learning languages",
    "Technology / Coding",
    "Spending time with family and friends",
    "Meditation / Mindfulness",
    "Prefer not to say",
    "Other",
  ];

  final Set<String> selectedInterests = {};
  String? otherText;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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

  Future<void> _saveToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'preferredInterests': {
          'interests': selectedInterests.toList(),
          'other': selectedInterests.contains("Other") ? otherText : null,
        },
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Information saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error saving data: $e")));
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
                      'Shared Interests Preferred',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: interestOptions.map((option) {
                        final isSelected = selectedInterests.contains(option);
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
                                selectedInterests.remove(option);
                                if (option == "Other") otherText = null;
                              } else {
                                selectedInterests.add(option);
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
                    const SizedBox(height: 20),
                    if (selectedInterests.contains("Other")) ...[
                      Text(
                        "Please specify other interest",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        onChanged: (val) => otherText = val,
                        decoration: InputDecoration(
                          hintText: "Your answer",
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
                      const SizedBox(height: 20),
                    ],
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
