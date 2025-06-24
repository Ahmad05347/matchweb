import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:match_web_app/comp/filter_dialog_content.dart';
import 'package:match_web_app/comp/sign_button.dart';
import 'package:match_web_app/database/database_service.dart';
import 'package:match_web_app/pages/payment_page.dart';
import 'package:match_web_app/profile/user_profile.dart';
import 'package:match_web_app/widgets/hover_profile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> allProfiles = [];
  List<Map<String, dynamic>> filteredProfiles = [];
  bool isLoading = true;
  String searchQuery = '';
  Map<String, dynamic> appliedFilters = {};

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final fetchedProfiles = await fetchAllUserProfiles();
    final profiles = fetchedProfiles
        .where((p) => p['id'] != currentUserId)
        .toList();
    setState(() {
      allProfiles = profiles;
      filteredProfiles = profiles;
      isLoading = false;
    });
  }

  void _handleAction(int index, String actionType) {
    setState(() => filteredProfiles.removeAt(index));
  }

  void _filterProfiles() {
    List<Map<String, dynamic>> temp = allProfiles;

    if (searchQuery.isNotEmpty) {
      temp = temp.where((profile) {
        final query = searchQuery.toLowerCase();
        return (profile['name'] ?? '').toLowerCase().contains(query) ||
            (profile['description'] ?? '').toLowerCase().contains(query) ||
            (profile['city'] ?? '').toLowerCase().contains(query) ||
            (profile['occupation'] ?? '').toLowerCase().contains(query) ||
            (profile['educationLevel'] ?? '').toLowerCase().contains(query) ||
            (profile['languages'] ?? '').toLowerCase().contains(query) ||
            (profile['height'] ?? '').toLowerCase().contains(query) ||
            (profile['age']?.toString() ?? '').contains(query);
      }).toList();
    }

    if (appliedFilters.isNotEmpty) {
      temp = temp.where((profile) {
        bool matches = true;
        appliedFilters.forEach((key, value) {
          if (value != null && value.toString().isNotEmpty) {
            if (key == 'ageRange') {
              final age = profile['age'] ?? 0;
              final range = value as RangeValues;
              if (age < range.start || age > range.end) matches = false;
            } else {
              if ((profile[key] ?? '').toLowerCase() !=
                  value.toString().toLowerCase()) {
                matches = false;
              }
            }
          }
        });
        return matches;
      }).toList();
    }

    setState(() => filteredProfiles = temp);
  }

  Future<void> showFilterDialog(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFf8f4f2),
      builder: (_) => const FilterDialogContent(),
    );

    if (result != null) {
      setState(() {
        appliedFilters = result;
      });
      _filterProfiles();
    }
  }

  void removeProfile(int index) {
    setState(() => filteredProfiles.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8f4f2),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 250,
            color: const Color(0xFFf8f4f2),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DASHBOARD",
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF573746),
                  ),
                ),
                const SizedBox(height: 40),
                _drawerItem("Profile", Icons.person, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UsersProfile()),
                  );
                }),
                const SizedBox(height: 20),
                _drawerItem("Matches", Icons.favorite_outline, () {}),
                const SizedBox(height: 20),
                _drawerItem("Settings", Icons.settings_outlined, () {}),
                const SizedBox(height: 20),
                _drawerItem("Payment Plan", Icons.payment_rounded, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PaymentPage()),
                  );
                }),
                const Spacer(),
                SignButton(text: "Logout", onTap: () {}),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : filteredProfiles.isEmpty
                  ? const Text(
                      "No users available at the moment.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF573746),
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          _buildSearchAndFilterBar(context),
                          const SizedBox(height: 30),
                          _buildProfileGrid(),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF573746)),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF573746),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Search",
              icon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
              _filterProfiles();
            },
          ),
        ),
        const SizedBox(width: 16),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () => showFilterDialog(context),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileGrid() {
    return Center(
      child: SizedBox(
        width: 1000,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 2 / 3,
          ),
          itemCount: filteredProfiles.length,
          itemBuilder: (context, index) {
            final profile = filteredProfiles[index];
            return HoverProfileCard(
              profile: profile,
              onAccept: () => _handleAction(index, 'accept'),
              onReject: () => _handleAction(index, 'reject'),
            );
          },
        ),
      ),
    );
  }
}
