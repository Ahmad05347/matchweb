const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();

exports.calculateAllCompatibilityScores = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
  const usersSnapshot = await db.collection('users').get();
  const allUsers = usersSnapshot.docs.map(doc => ({ id: doc.id, data: doc.data() }));

  for (let i = 0; i < allUsers.length; i++) {
    const userA = allUsers[i];
    for (let j = 0; j < allUsers.length; j++) {
      if (i === j) continue;
      const userB = allUsers[j];

      const result = calculateScore(userA, userB);
      await db
        .collection('compatibilityScores')
        .doc(userA.id)
        .collection('scores')
        .doc(userB.id)
        .set({
          ...result,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });
    }
  }

  return null;
});

function calculateScore(userA, userB) {
  const preferences = userA.data;
  const profile = userB.data;

  let score = 0;
  let total = 0;
  let sharedTags = new Set();
  let details = [];

  function add(condition, weight, explanation, category) {
    total += weight;
    if (condition) score += weight;
    details.push({
      match: condition,
      category,
      pointsAwarded: condition ? weight : 0,
      weight,
      explanation,
    });
  }

  const pref = preferences.personalPreferences || {};
  const prof = profile.personalInfo || {};

  // Personal
  add(prof.gender === pref.preferred_gender, 6, 'Gender matches', 'Personal');
  const age = prof.age || 0;
  const minAge = parseInt(pref.preferred_age_min || '0');
  const maxAge = parseInt(pref.preferred_age_max || '100');
  add(age >= minAge && age <= maxAge, 6, 'Age in preferred range', 'Personal');
  add(prof.cityAndCountry === pref.preferred_city, 4, 'City matches', 'Location');
  const countryMatch = (pref.preferred_country || []).includes((prof.cityAndCountry || '').split(',').pop()?.trim());
  add(countryMatch, 4, 'Country matches', 'Location');

  // Language
  const userLangs = Array.isArray(prof.language) ? prof.language : [prof.language];
  const prefLangs = preferences.personalPreferences?.preferred_languages || [];
  const commonLangs = userLangs.filter(lang => prefLangs.includes(lang));
  add(commonLangs.length > 0, 4, 'Common languages', 'Language');
  commonLangs.forEach(tag => sharedTags.add(tag));

  // Ethnicity
  add(pref.preferred_ethnicity === prof.ethnicity, 2, 'Ethnicity matches', 'Personal');

  // Religion
  const religionPref = preferences.religionPreferences || {};
  const religionProf = profile.religion || {};
  const sectList = religionPref.preferredSect || [];
  const religionList = religionPref.preferredReligion || [];
  add(religionList.includes(religionProf.Religion), 5, 'Religion matches', 'Religion');
  add(sectList.includes(religionProf.Sect), 3, 'Sect matches', 'Religion');
  add(religionPref.preferredCaste === religionProf.Caste, 2, 'Caste matches', 'Religion');

  // Education
  const eduPref = preferences.preferredEducation || {};
  const eduProf = profile.education || {};
  add(eduPref.educationLevel === eduProf.educationLevel, 5, 'Education matches', 'Education');
  add(eduPref.occupation === eduProf.occupation, 4, 'Occupation matches', 'Education');

  // Appearance
  const apPref = preferences.preferredAppearance || {};
  const apProf = profile.appearance || {};
  const h = apProf.height || 0;
  const hMin = apPref.preferredHeightRange?.min || 0;
  const hMax = apPref.preferredHeightRange?.max || 300;
  add(h >= hMin && h <= hMax, 4, 'Height in range', 'Appearance');
  add(apPref.preferredBodyType === apProf.bodyType, 3, 'Body type matches', 'Appearance');
  add(apPref.preferredSkinTone === apProf.skinTone, 2, 'Skin tone matches', 'Appearance');

  // Family & Lifestyle
  const famPref = preferences.preferredFamily || {};
  const famProf = profile.family_and_lifestyle || {};
  add(famPref.maritalStatus === famProf.marital_status, 4, 'Marital status matches', 'Family');
  add(famPref.acceptPartnerWithKids === famProf.do_you_want_kids, 3, 'Kids preference matches', 'Family');

  // Diet & Habits
  const dietPref = preferences.preferredDietAndHabits || {};
  const dietProf = profile.dietHabits || {};
  add(dietPref.preferredDiet === dietProf.diet, 3, 'Diet matches', 'Habits');
  add(dietPref.smokingAcceptable === dietProf.smoke, 2, 'Smoking preference matches', 'Habits');

  // Hobbies
  const hobPref = preferences.preferredHobbies?.hobbies || [];
  const hobProf = profile.hobbies || [];
  const commonHobbies = hobPref.filter(h => hobProf.includes(h));
  add(commonHobbies.length > 0, 3, 'Common hobbies', 'Interests');
  commonHobbies.forEach(tag => sharedTags.add(tag));

  // Interests
  const intPref = preferences.preferredInterests?.interests || [];
  const intProf = profile.interests || [];
  const commonInts = intPref.filter(i => intProf.includes(i));
  add(commonInts.length > 0, 3, 'Common interests', 'Interests');
  commonInts.forEach(tag => sharedTags.add(tag));

  // Personality
  const traitsPref = dietPref.preferredTopPersonalityTraits || [];
  const traitsProf = profile.personalityTraits || [];
  const matchTraits = traitsPref.filter(t => traitsProf.includes(t));
  add(matchTraits.length > 0, 4, 'Matching personality traits', 'Personality');
  matchTraits.forEach(tag => sharedTags.add(tag));

  const finalScore = total > 0 ? Math.round((score / total) * 100) : 0;

  return {
    score: finalScore,
    sharedTags: Array.from(sharedTags),
    details,
    raw: { achievedPoints: score, totalPoints: total },
  };
}
