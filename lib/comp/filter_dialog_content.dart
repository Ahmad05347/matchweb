import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterDialogContent extends StatefulWidget {
  const FilterDialogContent({super.key});

  @override
  State<FilterDialogContent> createState() => _FilterDialogContentState();
}

class _FilterDialogContentState extends State<FilterDialogContent>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  // Example filters (use real data sets from Firebase structure)
  String? selectedGender;
  RangeValues ageRange = const RangeValues(18, 40);
  String? selectedHeight;
  String? selectedBodyType;
  String? selectedSkinTone;
  String? selectedDiet;
  String? selectedSmoking;
  String? selectedReligion;

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> heightOptions = ['4.5', '5.0', '5.5', '6.0', '6.5', '7.0'];
  final List<String> bodyTypes = [
    'Slim',
    'Athletic',
    'Average',
    'Curvy',
    'Plus Size',
    'Prefer not to say',
  ];
  final List<String> skinTones = [
    'Fair',
    'Medium',
    'Dark',
    'Prefer not to say',
  ];
  final List<String> dietOptions = ['Vegetarian', 'Non-Vegetarian', 'Vegan'];
  final List<String> smokingOptions = ['Yes', 'No'];
  final List<String> religionOptions = [
    'Islam',
    'Christianity',
    'Hinduism',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? value,
    void Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(
                  "Filter Users",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  "Gender",
                  genderOptions,
                  selectedGender,
                  (val) => setState(() => selectedGender = val),
                ),
                _buildDropdown(
                  "Height (ft)",
                  heightOptions,
                  selectedHeight,
                  (val) => setState(() => selectedHeight = val),
                ),
                _buildDropdown(
                  "Body Type",
                  bodyTypes,
                  selectedBodyType,
                  (val) => setState(() => selectedBodyType = val),
                ),
                _buildDropdown(
                  "Skin Tone",
                  skinTones,
                  selectedSkinTone,
                  (val) => setState(() => selectedSkinTone = val),
                ),
                _buildDropdown(
                  "Diet Preference",
                  dietOptions,
                  selectedDiet,
                  (val) => setState(() => selectedDiet = val),
                ),
                _buildDropdown(
                  "Smoking",
                  smokingOptions,
                  selectedSmoking,
                  (val) => setState(() => selectedSmoking = val),
                ),
                _buildDropdown(
                  "Religion",
                  religionOptions,
                  selectedReligion,
                  (val) => setState(() => selectedReligion = val),
                ),
                const SizedBox(height: 12),
                Text(
                  "Age Range: ${ageRange.start.round()} - ${ageRange.end.round()}",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                RangeSlider(
                  values: ageRange,
                  min: 18,
                  max: 70,
                  divisions: 52,
                  activeColor: Colors.indigo,
                  labels: RangeLabels(
                    ageRange.start.round().toString(),
                    ageRange.end.round().toString(),
                  ),
                  onChanged: (values) => setState(() => ageRange = values),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Hook in logic later
                        },
                        child: const Text(
                          "Apply Filters",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => setState(() {
                          selectedGender = null;
                          selectedHeight = null;
                          selectedBodyType = null;
                          selectedSkinTone = null;
                          selectedDiet = null;
                          selectedSmoking = null;
                          selectedReligion = null;
                          ageRange = const RangeValues(18, 40);
                        }),
                        child: const Text("Reset"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
