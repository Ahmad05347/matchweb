import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class EducationAndCareer extends StatefulWidget {
  const EducationAndCareer({super.key});

  @override
  State<EducationAndCareer> createState() => _EducationAndCareerState();
}

class _EducationAndCareerState extends State<EducationAndCareer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  String? educationLevel;
  String? highSchool;
  String? income;
  String? occupation;

  final TextEditingController universityController = TextEditingController();
  final TextEditingController casteController = TextEditingController();

  final List<String> occupations = [
    'Accountant / Finance Professional',
    'Architect',
    'Armed Forces / Police',
    'Banker',
    'Business Owner / Entrepreneur',
    'Civil Servant / Government Employee',
    'Creative Professional (Writer, Designer, Artist)',
    'Doctor',
    'Engineer',
    'Healthcare Worker (Nurse, Pharmacist, etc.)',
    'Homemaker',
    'Lawyer',
    'Marketing / Sales Professional',
    'Media / Journalist',
    'Software Developer / IT Professional',
    'Teacher / Lecturer',
    'Retired',
    'Student',
    'Not Currently Working',
    'Prefer not to say',
    'Other',
  ];

  final List<String> languagesToLearn = [
    'Arabic',
    'Spanish',
    'Turkish',
    'French',
    'Sign Language',
    'German',
    'Mandarin',
    'Urdu',
    'English',
    'Other',
  ];

  final Set<String> selectedLanguages = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
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

  @override
  void dispose() {
    _controller.dispose();
    universityController.dispose();
    casteController.dispose();
    super.dispose();
  }

  Future<void> _saveData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final data = {
        'education': {
          'educationLevel': educationLevel,
          'highSchool': highSchool,
          'university': universityController.text,
          'occupation': occupation,
          'income': income,
          'languagesToLearn': selectedLanguages.toList(),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
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

  Widget _buildDropdown(
    String label,
    List<String> options,
    String? value,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: options
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
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
                      'Education & Career',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildDropdown(
                      'Education Level',
                      [
                        'Below high school',
                        'High School',
                        'Bachelor’s',
                        'Master’s',
                        'PhD',
                        'Professional Degree',
                        'Other',
                      ],
                      educationLevel,
                      (val) => setState(() => educationLevel = val),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      'High School',
                      [
                        'O Levels / A Levels',
                        'Matric / FSC',
                        'IB (International Baccalaureate)',
                        'Madrassa / Dars-e-Nizami',
                        'Homeschooling',
                        'Other',
                      ],
                      highSchool,
                      (val) => setState(() => highSchool = val),
                    ),
                    const SizedBox(height: 16),

                    _buildTextField('University Name', universityController),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      'Occupation',
                      occupations,
                      occupation,
                      (val) => setState(() => occupation = val),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      'Monthly Income',
                      [
                        'No Income',
                        'Less than PKR 50,000/month',
                        'PKR 50,000 – 100,000/month',
                        'PKR 100,001 – 200,000/month',
                        'PKR 200,001 – 300,000/month',
                        'PKR 300,001 – 500,000/month',
                        'PKR 500,001 – 1,000,000/month',
                        'More than PKR 1,000,000/month',
                        'Prefer not to say',
                        'Other',
                        'Varies',
                      ],
                      income,
                      (val) => setState(() => income = val),
                    ),

                    const SizedBox(height: 20),
                    Text(
                      'Languages I want to learn',
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: languagesToLearn.map((lang) {
                        final selected = selectedLanguages.contains(lang);
                        return FilterChip(
                          label: Text(
                            lang,
                            style: GoogleFonts.poppins(
                              color: selected ? Colors.white : Colors.black87,
                            ),
                          ),
                          selected: selected,
                          onSelected: (_) => setState(() {
                            if (selected) {
                              selectedLanguages.remove(lang);
                            } else {
                              selectedLanguages.add(lang);
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
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _saveData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8f5a56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 14,
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
