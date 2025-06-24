import 'dart:html' as html;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyLifestyle extends StatefulWidget {
  const FamilyLifestyle({super.key});

  @override
  State<FamilyLifestyle> createState() => _FamilyLifestyleState();
}

class _FamilyLifestyleState extends State<FamilyLifestyle>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  String? maritalStatus;
  String? wantKids;
  String? livingSituation;
  String? willingToRelocate;
  String? familyInvolvement;

  final TextEditingController fatherOccupationController =
      TextEditingController();
  final TextEditingController motherOccupationController =
      TextEditingController();
  final TextEditingController siblingsOccupationController =
      TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController siblingsCountController = TextEditingController();
  html.File? cnicFile;
  String? parentsStatus;
  String? siblingsMaritalStatus;
  String? familyLivingSituation;
  String? settlementTimeline;
  String? selectedFatherOccupation;
  String? selectedMotherOccupation;

  final List<String> parentStatusOptions = [
    'Married',
    'Divorced',
    'Separated',
    'Mother Deceased',
    'Father Deceased',
  ];

  final List<String> siblingsMaritalOptions = [
    'Single',
    'Divorced',
    'Widowed',
    'Separated',
    'Married',
  ];

  final List<String> familyLivingOptions = [
    'Joint family',
    'Living alone',
    'Living with roomate(s)',
  ];

  final List<String> settlementTimelines = [
    'As soon as possible',
    'Within a year',
    '1–2 years',
    'No timeline',
  ];

  final List<String> involvementDropdownOptions = [
    'Highly involved – I want my family to be part of every step',
    'Somewhat involved – I’ll make the decision but with family input',
    'Minimal involvement – I prefer to introduce them after initial compatibility',
    'Not involved – I’m making this decision independently',
    'Open to discussion / Depends on the match',
    'Prefer not to say',
  ];

  final List<String> sharedOccupations = [
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

  final Set<String> selectedSiblingsOccupations = {};

  final List<String> maritalOptions = [
    "Single",
    "Divorced",
    "Widowed",
    "Separated",
    "Prefer not to say",
    "Married",
  ];

  final List<String> kidsOptions = ["Yes", "No", "Maybe"];

  final List<String> livingOptions = [
    "Own house",
    "Alone",
    "With Family",
    "With Roommates",
  ];

  final List<String> relocateOptions = ["Yes", "No"];

  final List<String> involvementOptions = [
    "Early involvement",
    "Once it’s serious",
    "Minimal",
  ];

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
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15),
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

  void _saveData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final data = {
        "family_and_lifestyle": {
          'marital_status': maritalStatus,
          'parents_status': parentsStatus,
          'father_occupation': fatherOccupationController.text,
          'mother_occupation': motherOccupationController.text,
          'contact_number': contactNumberController.text,
          'number_of_siblings': siblingsCountController.text,
          'siblings_marital_status': siblingsMaritalStatus,
          'siblings_occupations': selectedSiblingsOccupations.toList(),
          'do_you_want_kids': wantKids,
          'housing_situation': livingSituation,
          'family_living_situation': familyLivingSituation,
          'willing_to_relocate': willingToRelocate,
          'settlement_timeline': settlementTimeline,
          'family_involvement': familyInvolvement,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Family & Lifestyle',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _buildDropdown(
                  "Marital Status",
                  maritalOptions,
                  maritalStatus,
                  (val) => setState(() => maritalStatus = val),
                ),
                _buildDropdown(
                  "Parents' Status",
                  parentStatusOptions,
                  parentsStatus,
                  (val) => setState(() => parentsStatus = val),
                ),
                _buildDropdown(
                  "Father's Occupation",
                  sharedOccupations,
                  fatherOccupationController.text,
                  (val) => setState(
                    () => fatherOccupationController.text = val ?? '',
                  ),
                ),

                _buildDropdown(
                  "Mother's Occupation",
                  sharedOccupations,
                  motherOccupationController.text,
                  (val) => setState(
                    () => motherOccupationController.text = val ?? '',
                  ),
                ),

                _buildTextField(
                  "Father/Mother's Contact Number",
                  contactNumberController,
                  inputType: TextInputType.phone,
                ),
                _buildTextField(
                  "Number of Siblings",
                  siblingsCountController,
                  inputType: TextInputType.number,
                ),
                _buildDropdown(
                  "Siblings' Marital Status",
                  siblingsMaritalOptions,
                  siblingsMaritalStatus,
                  (val) => setState(() => siblingsMaritalStatus = val),
                ),
                Text(
                  "Siblings' Occupations",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: sharedOccupations.map((occupation) {
                    final isSelected = selectedSiblingsOccupations.contains(
                      occupation,
                    );
                    return FilterChip(
                      label: Text(
                        occupation,
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) => setState(() {
                        if (isSelected) {
                          selectedSiblingsOccupations.remove(occupation);
                        } else {
                          selectedSiblingsOccupations.add(occupation);
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
                _buildDropdown(
                  "Housing Situation",
                  [
                    'Own house',
                    'Alone',
                    'With Family',
                    'With Roommates',
                    'Renting',
                  ],
                  livingSituation,
                  (val) => setState(() => livingSituation = val),
                ),
                _buildDropdown(
                  "Family Living Situation",
                  familyLivingOptions,
                  familyLivingSituation,
                  (val) => setState(() => familyLivingSituation = val),
                ),
                _buildDropdown(
                  "Willing to Relocate?",
                  ['Yes', 'No', 'Maybe'],
                  willingToRelocate,
                  (val) => setState(() => willingToRelocate = val),
                ),
                _buildDropdown(
                  "How soon are you looking to settle down?",
                  settlementTimelines,
                  settlementTimeline,
                  (val) => setState(() => settlementTimeline = val),
                ),
                _buildDropdown(
                  "Family involvement preference in the marriage process",
                  involvementDropdownOptions,
                  familyInvolvement,
                  (val) => setState(() => familyInvolvement = val),
                ),

                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8f5a56),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    String? selectedValue,
    void Function(String?) onChanged,
  ) {
    final safeValue = options.contains(selectedValue) ? selectedValue : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: safeValue,
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
}
