import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<Map<String, dynamic>>> fetchAllUserProfiles() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return [];

  final querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .get();

  return querySnapshot.docs
      .where((doc) => doc.id != currentUser.uid) // 👈 Exclude current user
      .map((doc) {
        final data = doc.data();
        final info = data['personalInfo'] ?? {};
        final appearance = data['appearance'] ?? {};
        final education = data['education'] ?? {};
        return {
          'name':
              "${info['firstName'] ?? ''} ${info['middleName'] ?? ''} ${info['lastName'] ?? ''}"
                  .trim(),
          'age': info['age'] ?? 0,
          'city': info['cityAndCountry'] ?? 'Unknown',
          'description': info['description'] ?? '',
          'image':
              "assets/images/WhatsApp Image 2025-01-17 at 23.29.04_731460b3.jpg", // Placeholder
          'height': appearance['Height (ft)'] ?? 'Unknown',
          'educationLevel': education['educationLevel'] ?? 'Not specified',
          'occupation': education['occupation'] ?? 'Not specified',
          'languages':
              (education['languagesToLearn'] as List?)?.join(', ') ?? 'None',
        };
      })
      .toList();
}
