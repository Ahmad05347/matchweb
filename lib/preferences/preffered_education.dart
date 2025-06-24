import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrefferedEducation extends StatefulWidget {
  const PrefferedEducation({super.key});

  @override
  State<PrefferedEducation> createState() => _PrefferedEducationState();
}

class _PrefferedEducationState extends State<PrefferedEducation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  String? selectedEducation;
  String? selectedOccupation;
  String? selectedIncome;
  String? otherOccupation;

  final List<String> educationOptions = [
    'Below high school',
    'High School',
    'Bachelor’s',
    'Master’s',
    'PhD',
    'Professional Degree',
    'Other',
  ];

  final List<String> incomeOptions = [
    'No Income',
    'Less than PKR 50,000/month',
    'PKR 50,000–100,000/month',
    'PKR 100,000–200,000/month',
    'PKR 200,000–300,000/month',
    'PKR 300,000–500,000/month',
    'PKR 500,000–1,000,000/month',
    'More than PKR 1,000,000/month',
    'Prefer not to say',
  ];

  final List<String> occupationOptions = [
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

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: GoogleFonts.poppins()),
                ),
              )
              .toList(),
          onChanged: onChanged,
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

  Widget _buildTextField(
    String label,
    String? value,
    Function(String) onChanged,
  ) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: GoogleFonts.poppins(),
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
      style: GoogleFonts.poppins(),
    );
  }

  Future<void> _saveToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'preferredEducation': {
          'educationLevel': selectedEducation,
          'occupation': selectedOccupation == 'Other'
              ? otherOccupation
              : selectedOccupation,
          'monthlyIncome': selectedIncome,
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
                      'Education & Career Preferences',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildChipGroup(
                      'Minimum Education Level',
                      educationOptions,
                      selectedEducation,
                      (val) => setState(() => selectedEducation = val),
                    ),
                    _buildDropdown(
                      label: "Preferred Occupation",
                      items: occupationOptions,
                      value: selectedOccupation,
                      onChanged: (val) =>
                          setState(() => selectedOccupation = val),
                    ),
                    if (selectedOccupation == 'Other')
                      _buildTextField(
                        "Specify other occupation",
                        otherOccupation,
                        (val) => setState(() => otherOccupation = val),
                      ),
                    _buildChipGroup(
                      'Minimum Monthly Income',
                      incomeOptions,
                      selectedIncome,
                      (val) => setState(() => selectedIncome = val),
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
