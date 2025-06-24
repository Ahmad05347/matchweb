import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreferencesStep extends StatefulWidget {
  const PreferencesStep({super.key});

  @override
  State<PreferencesStep> createState() => _PreferencesStepState();
}

class _PreferencesStepState extends State<PreferencesStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  String? selectedPreference;
  String? selectedGender;
  final TextEditingController _ageRangeController = TextEditingController();
  final TextEditingController _customPreferenceController =
      TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _laughController = TextEditingController();
  final TextEditingController _funFactController = TextEditingController();
  final TextEditingController _weekendController = TextEditingController();
  final TextEditingController _neverController = TextEditingController();

  String? selectedAstrologicalSign;
  String? selectedCountry;
  String? settleDown;

  final Set<String> selectedTraits = {};
  final Set<String> selectedLoveLanguages = {};
  final Set<String> selectedDealbreakers = {};

  bool showCustomField = false;

  final List<String> personalityTraits = [
    'Loyal',
    'Ambitious',
    'Introverted',
    'Creative',
    'Funny',
    'Kind',
    'Outgoing',
    'Spiritual',
  ];

  final List<String> loveLanguages = [
    'Words of Affirmation',
    'Quality Time',
    'Acts of Service',
    'Physical Touch',
    'Gifts',
  ];

  final List<String> dealbreakers = [
    'Smoking',
    'Long-distance',
    'Doesn’t want kids',
    'Drinks',
    'Different religion',
  ];

  final List<String> astrologicalSigns = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces',
  ];

  final List<String> countries = [
    'Japan',
    'Turkey',
    'Iceland',
    'France',
    'Italy',
    'Australia',
    'USA',
    'Pakistan',
    'Canada',
  ];

  final List<String> settleOptions = [
    'ASAP',
    'Within a year',
    '1–2 years',
    'No timeline',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _opacity = Tween<double>(
      begin: 0,
      end: 1,
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
    _ageRangeController.dispose();
    _customPreferenceController.dispose();
    _aboutMeController.dispose();
    _laughController.dispose();
    _funFactController.dispose();
    _weekendController.dispose();
    _neverController.dispose();
    super.dispose();
  }

  Future<void> saveToFirebase() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          "preferences": {
            'lookingFor': selectedPreference,
            'preferredGender': selectedGender,
            'ageRange': _ageRangeController.text,
            'aboutMe': _aboutMeController.text,
            'laughReason': _laughController.text,
            'funFact': _funFactController.text,
            'idealWeekend': _weekendController.text,
            'iWouldNever': _neverController.text,
            'personalityTraits': selectedTraits.toList(),
            'astrologicalSign': selectedAstrologicalSign,
            'loveLanguages': selectedLoveLanguages.toList(),
            'dreamDestination': selectedCountry,
            'settleTimeline': settleDown,
            'dealbreakers': selectedDealbreakers.toList(),
          },
        }, SetOptions(merge: true));
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferences saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving preferences: $e')));
    }
  }

  Widget _buildChips(
    String title,
    List<String> options,
    Set<String> selectedSet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: options.map((label) {
            final isSelected = selectedSet.contains(label);
            return FilterChip(
              label: Text(
                label,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  isSelected
                      ? selectedSet.remove(label)
                      : selectedSet.add(label);
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
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDropdown(
    String title,
    List<String> items,
    String? selectedItem,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: selectedItem,
          decoration: _inputDecoration(hint: 'Select...'),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 20),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildChoiceChip('Friendship', Icons.handshake),
                        _buildChoiceChip('Relationship', Icons.favorite),
                        _buildChoiceChip('Marriage', Icons.ring_volume),
                        _buildChoiceChip('Other', Icons.help_outline),
                      ],
                    ),
                    if (showCustomField)
                      TextField(
                        controller: _customPreferenceController,
                        decoration: _inputDecoration(
                          hint: 'Enter your preference',
                        ),
                      ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _aboutMeController,
                      maxLines: 4,
                      decoration: _inputDecoration(hint: 'About me'),
                    ),
                    const SizedBox(height: 20),
                    _buildChips(
                      'Top 3 Personality Traits',
                      personalityTraits,
                      selectedTraits,
                    ),
                    _buildDropdown(
                      'Astrological Sign',
                      astrologicalSigns,
                      selectedAstrologicalSign,
                      (val) => setState(() => selectedAstrologicalSign = val),
                    ),
                    _buildChips(
                      'Love Language',
                      loveLanguages,
                      selectedLoveLanguages,
                    ),
                    TextField(
                      controller: _laughController,
                      decoration: _inputDecoration(
                        hint: 'What makes you laugh?',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _funFactController,
                      decoration: _inputDecoration(
                        hint: 'Random fun fact about you',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _weekendController,
                      decoration: _inputDecoration(hint: 'Ideal weekend'),
                    ),
                    const SizedBox(height: 20),
                    _buildDropdown(
                      'Dream Travel Destination',
                      countries,
                      selectedCountry,
                      (val) => setState(() => selectedCountry = val),
                    ),
                    TextField(
                      controller: _neverController,
                      decoration: _inputDecoration(hint: 'I would never...'),
                    ),
                    const SizedBox(height: 20),
                    _buildDropdown(
                      'How soon are you looking to settle down?',
                      settleOptions,
                      settleDown,
                      (val) => setState(() => settleDown = val),
                    ),
                    _buildChips(
                      'Dealbreakers',
                      dealbreakers,
                      selectedDealbreakers,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: saveToFirebase,
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

  Widget _buildChoiceChip(String label, IconData icon) {
    final isSelected = selectedPreference == label;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? Colors.white : Colors.black87,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          selectedPreference = label;
          showCustomField = label == 'Other';
          if (!showCustomField) _customPreferenceController.clear();
        });
      },
      selectedColor: const Color(0xFFb58f86),
      backgroundColor: const Color(0xFFf5f5f5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      labelPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    );
  }
}

InputDecoration _inputDecoration({String hint = ''}) => InputDecoration(
  filled: true,
  fillColor: const Color(0xFFfdfdfd),
  hintText: hint,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide.none,
  ),
);
