import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InterestsStep extends StatefulWidget {
  const InterestsStep({super.key});

  @override
  State<InterestsStep> createState() => _InterestsStepState();
}

class _InterestsStepState extends State<InterestsStep>
    with SingleTickerProviderStateMixin {
  final Set<String> selectedInterests = {};
  final TextEditingController otherInterestController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  final List<String> interestsList = [
    'Faith',
    'Family Life',
    'Personal Growth & Self-improvement',
    'Career Development',
    'Entrepreneurship',
    'Health & Fitness',
    'Arts',
    'Culture',
    'Travel & Exploration',
    'Food',
    'Cooking',
    'Technology & Innovation',
    'Music',
    'Books',
    'Literature',
    'Movies & TV Shows',
    'Social Causes & Volunteering',
    'Fashion & Style',
    'Education & Learning',
    'Nature & Outdoors',
    'Politics',
    'Current Events',
    'Finance & Investing',
    'Public Speaking',
    'Debating',
    'Pop Culture',
    'Animals',
    'Pets',
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
    otherInterestController.dispose();
    super.dispose();
  }

  Future<void> _saveToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final List<String> interests = selectedInterests.toList();
    if (selectedInterests.contains('Other') &&
        otherInterestController.text.trim().isNotEmpty) {
      interests.add(otherInterestController.text.trim());
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'interests': interests,
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Interests saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving interests: $e')));
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
                      'Select Your Interests',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: interestsList.map((interest) {
                        final isSelected = selectedInterests.contains(interest);
                        return FilterChip(
                          label: Text(
                            interest,
                            style: GoogleFonts.poppins(
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              if (isSelected) {
                                selectedInterests.remove(interest);
                              } else {
                                selectedInterests.add(interest);
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
                    if (selectedInterests.contains('Other')) ...[
                      const SizedBox(height: 20),
                      Text(
                        'Please specify other interest:',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: otherInterestController,
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
