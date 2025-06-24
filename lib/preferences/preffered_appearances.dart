import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrefferedAppearances extends StatefulWidget {
  const PrefferedAppearances({super.key});

  @override
  State<PrefferedAppearances> createState() => _PrefferedAppearancesState();
}

class _PrefferedAppearancesState extends State<PrefferedAppearances>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  final List<String> bodyTypes = [
    'Slim',
    'Athletic',
    'Average',
    'Plus Size',
    'Prefer not to say',
  ];

  final List<String> skinTones = [
    'Fair',
    'Medium',
    'Dark',
    'Prefer not to say',
  ];

  final List<String> disabilitiesOptions = ['Yes', 'No', 'Prefer not to say'];

  final List<String> heightValues = [
    for (int feet = 4; feet <= 6; feet++)
      for (int inch = 0; inch < 12; inch++)
        if (!(feet == 4 && inch < 5) && !(feet == 6 && inch > 5))
          "$feet'$inch\"",
  ];

  String? minHeight;
  String? maxHeight;
  String? selectedBodyType;
  String? selectedSkinTone;
  String? openToDisabilities;

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
        'preferredAppearance': {
          'preferredHeightRange': {'min': minHeight, 'max': maxHeight},
          'preferredBodyType': selectedBodyType,
          'preferredSkinTone': selectedSkinTone,
          'openToPartnerWithDisabilities': openToDisabilities,
        },
      }, SetOptions(merge: true));

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

  Widget _buildDropdown(
    String label,
    List<String> options,
    String? value,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
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
                      'Appearance Preferences',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            "Minimum Height",
                            heightValues,
                            minHeight,
                            (val) => setState(() => minHeight = val),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdown(
                            "Maximum Height",
                            heightValues,
                            maxHeight,
                            (val) => setState(() => maxHeight = val),
                          ),
                        ),
                      ],
                    ),
                    _buildDropdown(
                      "Preferred Body Type",
                      bodyTypes,
                      selectedBodyType,
                      (val) => setState(() => selectedBodyType = val),
                    ),
                    _buildDropdown(
                      "Preferred Skin Tone",
                      skinTones,
                      selectedSkinTone,
                      (val) => setState(() => selectedSkinTone = val),
                    ),
                    _buildDropdown(
                      "Open to Partner with Disabilities?",
                      disabilitiesOptions,
                      openToDisabilities,
                      (val) => setState(() => openToDisabilities = val),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: _saveToFirebase,
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
        ),
      ),
    );
  }
}
