class MatchmakingService {
  static int calculateCoreLocationScore(
    Map<String, dynamic> userPrefs,
    Map<String, dynamic> candidateData,
  ) {
    int score = 0;

    // Age (14 points)
    int candidateAge = candidateData['personalInfo']?['age'] ?? 0;
    int minAge = userPrefs['minPreferredAge'] ?? 18;
    int maxAge = userPrefs['maxPreferredAge'] ?? 99;
    if (candidateAge >= minAge && candidateAge <= maxAge) {
      score += 14;
    }

    // Height (5 points)
    double candidateHeight =
        double.tryParse(
          candidateData['appearance']?['height']?.toString() ?? '',
        ) ??
        0.0;
    double minHeight = userPrefs['minPreferredHeight'] ?? 0.0;
    double maxHeight = userPrefs['maxPreferredHeight'] ?? 300.0;
    if (candidateHeight >= minHeight && candidateHeight <= maxHeight) {
      score += 5;
    }

    // City (4 points)
    if (userPrefs['preferredCity'] != null &&
        userPrefs['preferredCity'] ==
            candidateData['personalInfo']?['cityAndCountry']) {
      score += 4;
    }

    // Country (4 points)
    if (userPrefs['preferredCountry'] != null &&
        candidateData['personalInfo']?['cityAndCountry']?.contains(
              userPrefs['preferredCountry'],
            ) ==
            true) {
      score += 4;
    }

    // Caste (2 points)
    if (userPrefs['preferredCaste'] != null &&
        userPrefs['preferredCaste'] == candidateData['religion']?['Caste']) {
      score += 2;
    }

    // Ethnicity (2 points)
    if (userPrefs['preferredEthnicity'] != null &&
        userPrefs['preferredEthnicity'] ==
            candidateData['personalInfo']?['ethnicity']) {
      score += 2;
    }

    return score;
  }
}
