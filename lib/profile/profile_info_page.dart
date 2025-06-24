import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalInfoStep extends StatefulWidget {
  const PersonalInfoStep({super.key});

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  final TextEditingController firstName = TextEditingController();
  final TextEditingController middleName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController cityAndCountry = TextEditingController();
  final TextEditingController language = TextEditingController();
  final TextEditingController nationality = TextEditingController();
  final TextEditingController ethnicity = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController phonenumber = TextEditingController();

  String _selectedGender = '';
  bool isSaving = false;

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

  Future<void> _saveDataToFirebase() async {
    if (FirebaseAuth.instance.currentUser == null) return;

    setState(() => isSaving = true);

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'uid': userId,
        "personalInfo": {
          'firstName': firstName.text.trim(),
          'middleName': middleName.text.trim(),
          'lastName': lastName.text.trim(),
          'status': 'pending',
          'age': int.tryParse(age.text.trim()) ?? 0,
          'gender': _selectedGender,
          'cityAndCountry': cityAndCountry.text.trim(),
          'language': language.text.trim(),
          'nationality': nationality.text.trim(),
          'ethnicity': ethnicity.text.trim(),
          'description': description.text.trim(),
          'phoneNumber': phonenumber.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        },
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Information saved successfully!')),
      );
    } catch (e) {
      debugPrint('Error saving data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save information.')),
      );
    }

    setState(() => isSaving = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    firstName.dispose();
    middleName.dispose();
    lastName.dispose();
    age.dispose();
    cityAndCountry.dispose();
    language.dispose();
    nationality.dispose();
    ethnicity.dispose();
    description.dispose();
    phonenumber.dispose();
    _selectedGender = '';
    super.dispose();
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField('First Name', firstName),
                    const SizedBox(height: 16),
                    _buildTextField('Middle Name*', middleName),
                    const SizedBox(height: 16),
                    _buildTextField('Last Name', lastName),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Age',
                      age,
                      inputType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField('Phone Number', phonenumber),
                    const SizedBox(height: 16),
                    _buildTextField('City & Country', cityAndCountry),
                    const SizedBox(height: 16),
                    _buildTextField('Language Spoken', language),
                    const SizedBox(height: 16),
                    _buildTextField('Nationality', nationality),
                    const SizedBox(height: 16),
                    _buildTextField('Ethnicity', ethnicity),
                    const SizedBox(height: 16),
                    _buildTextField('Description', description, maxLines: 3),
                    const SizedBox(height: 20),
                    _buildGenderChips(),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isSaving ? null : _saveDataToFirebase,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        backgroundColor: const Color(0xFFb58f86),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Save",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
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

  Widget _buildGenderChips() {
    final genders = ['Male', 'Female', 'Non Binary', 'Prefer Not To Say'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: genders.map((gender) {
            final isSelected = _selectedGender == gender;
            return ChoiceChip(
              label: Text(
                gender,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _selectedGender = gender);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: const Color(0xFFf7f3f3),
              selectedColor: const Color(0xFFb58f86),
              labelPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
