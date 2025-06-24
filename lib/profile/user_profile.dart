import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:match_web_app/comp/user_button.dart';

class UsersProfile extends StatefulWidget {
  const UsersProfile({super.key});

  @override
  State<UsersProfile> createState() => _UsersProfileState();
}

class _UsersProfileState extends State<UsersProfile> {
  bool isEditing = false;
  bool isLoading = true;

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Map<String, dynamic> userData = {};
  Map<String, dynamic> familyLifestyleData = {};

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        userData = userDoc.data() ?? {};
      }
      final familyQuery = await FirebaseFirestore.instance
          .collection('family_and_lifestyle')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();
      if (familyQuery.docs.isNotEmpty) {
        familyLifestyleData = familyQuery.docs.first.data();
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }

    setState(() => isLoading = false);
  }

  Future<void> _saveChanges() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(userData, SetOptions(merge: true));
      if (familyLifestyleData.isNotEmpty) {
        final familyQuery = await FirebaseFirestore.instance
            .collection('family_and_lifestyle')
            .where('userId', isEqualTo: userId)
            .limit(1)
            .get();
        if (familyQuery.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('family_and_lifestyle')
              .doc(familyQuery.docs.first.id)
              .set(familyLifestyleData);
        } else {
          familyLifestyleData['userId'] = userId;
          await FirebaseFirestore.instance
              .collection('family_and_lifestyle')
              .add(familyLifestyleData);
        }
      }
      setState(() => isEditing = false);
    } catch (e) {
      debugPrint('Error saving changes: $e');
    }
  }

  Widget _buildEditableField(
    String label,
    dynamic value,
    void Function(String) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            enabled: isEditing,
            initialValue: value?.toString() ?? '',
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    Map<String, dynamic>? sectionData, {
    bool isUserDoc = true,
  }) {
    if (sectionData == null) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.indigo,
          ),
        ),
        const Divider(height: 20),
        ...sectionData.entries.map(
          (e) => _buildEditableField(
            e.key,
            e.value,
            (val) => setState(() {
              if (isUserDoc) {
                userData[title.toLowerCase()] ??= {};
                userData[title.toLowerCase()][e.key] = val;
              } else {
                familyLifestyleData[e.key] = val;
              }
            }),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "User Profile",
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(isEditing ? Icons.close : Icons.edit),
                        tooltip: isEditing ? "Cancel Editing" : "Edit Profile",
                        onPressed: () => setState(() => isEditing = !isEditing),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildSection("General", userData),

                  _buildSection("appearance", userData['appearance']),

                  _buildSection("dietHabits", userData['dietHabits']),

                  _buildSection("education", userData['education']),

                  _buildSection("religion", userData['religion']),

                  _buildEditableField(
                    "Interests",
                    (userData['interests'] ?? []).join(', '),
                    (val) =>
                        setState(() => userData['interests'] = val.split(', ')),
                  ),

                  _buildEditableField(
                    "Hobbies",
                    (userData['hobbies'] ?? []).join(', '),
                    (val) =>
                        setState(() => userData['hobbies'] = val.split(', ')),
                  ),

                  _buildEditableField(
                    "Description",
                    userData['description'],
                    (val) => setState(() => userData['description'] = val),
                  ),

                  _buildEditableField(
                    "Traits",
                    (userData['personalityTraits'] ?? []).join(', '),
                    (val) => setState(
                      () => userData['personalityTraits'] = val.split(', '),
                    ),
                  ),

                  _buildSection(
                    "Family & Lifestyle",
                    familyLifestyleData,
                    isUserDoc: false,
                  ),

                  const SizedBox(height: 30),

                  if (isEditing)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UserButton(
                          color: Colors.indigo,
                          text: "Save Changes",
                          isTrue: true,
                          onTap: _saveChanges,
                        ),
                        const SizedBox(width: 16),
                        UserButton(
                          color: Colors.grey,
                          text: "Cancel",
                          isTrue: true,
                          onTap: () => setState(() => isEditing = false),
                        ),
                      ],
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
