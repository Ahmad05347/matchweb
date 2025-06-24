import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalPreferences extends StatefulWidget {
  const PersonalPreferences({super.key});

  @override
  State<PersonalPreferences> createState() => _PersonalPreferencesState();
}

class _PersonalPreferencesState extends State<PersonalPreferences>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  String? preferredGender;
  String? preferredEthnicity;

  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController maxAgeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController casteController = TextEditingController();

  final Set<String> selectedCountries = {};
  final Set<String> selectedLanguages = {};

  final TextEditingController otherCountryController = TextEditingController();
  final TextEditingController otherLanguageController = TextEditingController();

  final List<String> genderOptions = ['Male', 'Female'];

  final List<String> ethnicityOptions = [
    'Punjabi',
    'Sindhi',
    'Pashtun / Pathan',
    'Balochi',
    'Muhajir / Urdu-speaking',
    'Kashmiri',
    'Gilgiti / Baltistani',
    'Saraiki',
    'Hindkowan',
    'Hazara',
    'Makrani',
    'Chitrali / Khowar',
    'Burusho / Hunzai',
    'Mixed Pakistani Heritage',
    'Afghan',
    'Indian',
    'Bangladeshi',
    'Middle Eastern',
    'Central Asian',
    'African Descent',
    'Other',
  ];

  final List<String> allCountries = [
    'Pakistan',
    'India',
    'UAE',
    'USA',
    'UK',
    'Canada',
    'Australia',
    'Other',
  ];

  final List<String> allLanguages = [
    'Urdu',
    'Punjabi',
    'Sindhi',
    'Pashto',
    'Balochi',
    'Saraiki',
    'English',
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

  Future<void> _saveToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final data = {
        'personalPreferences': {
          'preferred_gender': preferredGender,
          'preferred_age_min': minAgeController.text,
          'preferred_age_max': maxAgeController.text,
          'preferred_city': cityController.text,
          'preferred_country': selectedCountries.toList(),
          'preferred_country_other': selectedCountries.contains('Other')
              ? otherCountryController.text
              : null,
          'preferred_languages': selectedLanguages.toList(),
          'preferred_language_other': selectedLanguages.contains('Other')
              ? otherLanguageController.text
              : null,
          'preferred_caste': casteController.text,
          'preferred_ethnicity': preferredEthnicity,
        },
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(data, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Information saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving data: $e')));
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType inputType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: inputType,
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
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    String? selectedValue,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          onChanged: onChanged,
          items: options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
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

  Widget _buildChipSelector(
    String label,
    List<String> options,
    Set<String> selectedSet,
    void Function(String) onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((option) {
            final isSelected = selectedSet.contains(option);
            return ChoiceChip(
              label: Text(
                option,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => setState(() {
                if (isSelected) {
                  selectedSet.remove(option);
                } else {
                  selectedSet.add(option);
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
                      'Personal Preferences',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildDropdown(
                      'Preferred Gender',
                      genderOptions,
                      preferredGender,
                      (val) => setState(() => preferredGender = val),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'Preferred Min Age',
                            minAgeController,
                            inputType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            'Preferred Max Age',
                            maxAgeController,
                            inputType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    _buildTextField(
                      'Preferred City / Location',
                      cityController,
                    ),
                    _buildChipSelector(
                      'Preferred Countries',
                      allCountries,
                      selectedCountries,
                      (val) => setState(() {}),
                    ),
                    if (selectedCountries.contains('Other'))
                      _buildTextField(
                        'Please specify country',
                        otherCountryController,
                      ),
                    _buildChipSelector(
                      'Preferred Languages',
                      allLanguages,
                      selectedLanguages,
                      (val) => setState(() {}),
                    ),
                    if (selectedLanguages.contains('Other'))
                      _buildTextField(
                        'Please specify language',
                        otherLanguageController,
                      ),
                    _buildTextField(
                      'Preferred Caste (optional)',
                      casteController,
                    ),
                    _buildDropdown(
                      'Preferred Ethnicity',
                      ethnicityOptions,
                      preferredEthnicity,
                      (val) => setState(() => preferredEthnicity = val),
                    ),

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
                            horizontal: 32,
                            vertical: 14,
                          ),
                        ),
                        child: Text(
                          "Save",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
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
