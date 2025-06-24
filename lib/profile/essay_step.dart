import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EssayStep extends StatefulWidget {
  const EssayStep({super.key});

  @override
  State<EssayStep> createState() => _EssayStepState();
}

class _EssayStepState extends State<EssayStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  final _essayControllers = <String, TextEditingController>{};
  final int maxWords = 200;

  final List<String> essayQuestions = [
    'How would you briefly describe your relationship with your parents?',
    'How would you briefly describe the role you play in your household?',
    'Are any of your family members financially dependent on you? If yes, how will you navigate this after your marriage?',
    'How do you envision your life after marriage?',
    'Please briefly describe what your preferred living arrangement after marriage would be. Include a preferred location if it is of importance to you.',
    'How do you think finances should be managed within your marriage?',
    'What helps you be at your best? You can list activities, hobbies, habits, routines, etc.',
    'Briefly describe your career orientation and pursuing education after marriage?',
    'If having children is a priority for you, briefly describe that timeline for you.',
  ];

  @override
  void initState() {
    super.initState();
    for (var question in essayQuestions) {
      _essayControllers[question] = TextEditingController();
    }

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
    for (var controller in _essayControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  int _wordCount(String text) {
    return text
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
  }

  Future<void> _saveToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final Map<String, String> essays = {};
    for (var entry in _essayControllers.entries) {
      final text = entry.value.text.trim();
      if (text.isNotEmpty) {
        essays[entry.key] = text;
      }
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'essays': essays,
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Essays saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving essays: $e')));
    }
  }

  Widget _buildEssayField(String question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _essayControllers[question],
          maxLines: null,
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            hintText: 'Your response (max 200 words)',
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
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
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${_wordCount(_essayControllers[question]!.text)} / $maxWords words',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
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
                      'Essay Questions (Optional)',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 25),
                    ...essayQuestions.map(_buildEssayField),
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
