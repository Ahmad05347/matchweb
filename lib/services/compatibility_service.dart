// lib/services/compatibility_score_service.dart

class CompatibilityScoreService {
  static double calculateScore({
    required Map<String, dynamic> preferences,
    required Map<String, dynamic> profile,
  }) {
    double score = 0;
    double total = 0;

    void addScore(bool condition, double weight) {
      if (condition) score += weight;
      total += weight;
    }

    // 1. Gender
    addScore(preferences['preferred_gender'] == profile['gender'], 10);

    // 2. Age Range
    if (profile['age'] is int) {
      int age = profile['age'];
      int min = int.tryParse(preferences['preferred_age_min'] ?? '') ?? 0;
      int max = int.tryParse(preferences['preferred_age_max'] ?? '') ?? 100;
      addScore(age >= min && age <= max, 10);
    }

    // 3. Country
    if (preferences['preferred_country'] is List) {
      List preferredCountries = preferences['preferred_country'];
      addScore(preferredCountries.contains(profile['country']), 8);
    }

    // 4. City
    addScore(
      preferences['preferred_city']?.toLowerCase() ==
          profile['city']?.toLowerCase(),
      6,
    );

    // 5. Religion & Sect
    if (preferences['preferredReligion'] is List) {
      addScore(
        preferences['preferredReligion'].contains(profile['religion']),
        5,
      );
    }
    if (preferences['preferredSect'] is List) {
      addScore(preferences['preferredSect'].contains(profile['sect']), 5);
    }

    // 6. Education & Occupation
    addScore(preferences['educationLevel'] == profile['educationLevel'], 6);
    addScore(preferences['occupation'] == profile['occupation'], 4);

    // 7. Family Preferences
    addScore(preferences['maritalStatus'] == profile['maritalStatus'], 5);
    addScore(preferences['acceptPartnerWithKids'] == profile['hasKids'], 4);

    // 8. Appearance
    if (profile['height'] is double || profile['height'] is int) {
      double height = (profile['height'] as num).toDouble();
      double minH =
          preferences['preferredHeightRange']?['min']?.toDouble() ?? 0;
      double maxH =
          preferences['preferredHeightRange']?['max']?.toDouble() ?? 300;
      addScore(height >= minH && height <= maxH, 6);
    }
    addScore(preferences['preferredBodyType'] == profile['bodyType'], 3);

    // 9. Diet and Habits
    addScore(preferences['preferredDiet'] == profile['diet'], 4);
    addScore(preferences['smokingAcceptable'] == profile['smokes'], 2);

    // 10. Personality Traits
    if (preferences['preferredTopPersonalityTraits'] is List &&
        profile['personalityTraits'] is List) {
      List prefTraits = preferences['preferredTopPersonalityTraits'];
      List userTraits = profile['personalityTraits'];
      int matchCount = userTraits.where((t) => prefTraits.contains(t)).length;
      addScore(matchCount > 0, 5);
    }

    // 11. Hobbies & Interests
    if (preferences['hobbies'] is List && profile['hobbies'] is List) {
      List pref = preferences['hobbies'];
      List prof = profile['hobbies'];
      int matchCount = prof.where((h) => pref.contains(h)).length;
      addScore(matchCount > 0, 3);
    }
    if (preferences['interests'] is List && profile['interests'] is List) {
      List pref = preferences['interests'];
      List prof = profile['interests'];
      int matchCount = prof.where((i) => pref.contains(i)).length;
      addScore(matchCount > 0, 3);
    }

    // Final score percentage
    return total == 0 ? 0 : (score / total) * 100;
  }
}
