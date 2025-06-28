import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:match_web_app/pages/chat_page.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle('Mishqat — Terms of Use'),
                _SubText('Effective Date: 01 June 2025'),

                _SectionHeader('1. Acceptance of Terms'),
                _BulletText(
                  'By accessing or using our website, mobile application, or services, you agree to our Terms of Use and Privacy Policy.',
                ),

                _SectionHeader('2. Eligibility'),
                _BulletText(
                  'You must be at least 18 years old and legally capable under Pakistani law to use our Service.',
                ),

                _SectionHeader('3. User Registration & Account Security'),
                _BulletText(
                  'Provide accurate information and maintain your account security.',
                ),
                _BulletText(
                  'You are responsible for all activities under your account.',
                ),
                _BulletText(
                  'Report unauthorized access to Mishqat immediately.',
                ),

                _SectionHeader('4. User Data & Profile Information'),
                _BulletText(
                  'We collect and process your profile data according to our Privacy Policy.',
                ),
                _BulletText(
                  'Uploading images and preferences enhances your matching experience.',
                ),

                _SectionHeader('5. Connection Requests & Admin Approval'),
                _BulletText(
                  'Connection requests are subject to admin approval before being shown to recipients.',
                ),
                _BulletText(
                  'We reserve the right to approve or reject requests for safety and quality assurance.',
                ),

                _SectionHeader('6. Subscription Plans & Payments'),
                _BulletText(
                  'We offer monthly plans; payments recur automatically unless canceled.',
                ),
                _BulletText('Fees are non-refundable unless required by law.'),
                _BulletText(
                  'Cancel anytime via settings; access remains until billing cycle ends.',
                ),

                _SectionHeader('7. User Conduct & Responsibilities'),
                _BulletText(
                  'You agree to behave respectfully, avoid harassment, and use the platform lawfully.',
                ),
                _BulletText(
                  'Violations may lead to suspension or termination without notice.',
                ),

                _SectionHeader('8. Intellectual Property Rights'),
                _BulletText(
                  'All content is owned/licensed by Mishqat. Do not copy or redistribute without permission.',
                ),

                _SectionHeader('9. Limitation of Liability'),
                _BulletText(
                  'We provide the Service “as is” and are not liable for profile accuracy or damages.',
                ),

                _SectionHeader('10. Indemnification'),
                _BulletText(
                  'You agree to indemnify Mishqat for claims arising from your usage or violations.',
                ),

                _SectionHeader('11. Termination'),
                _BulletText(
                  'We may suspend or terminate your account for violations.',
                ),
                _BulletText(
                  'Upon termination, your right to use the Service ends immediately.',
                ),

                _SectionHeader('12. Governing Law and Dispute Resolution'),
                _BulletText(
                  'These Terms are governed by Pakistani law. Disputes will be resolved in Pakistani courts.',
                ),

                _SectionHeader('13. Changes to Terms'),
                _BulletText(
                  'We may update these Terms at any time. Continued use implies acceptance.',
                ),

                _SectionHeader(
                  '14. In-Person Meetings and Liability Disclaimer',
                ),
                _BulletText(
                  'Mishqat is not responsible for offline meetings. Exercise personal caution and meet in public.',
                ),

                _SectionHeader('15. Contact Us'),
                _BulletText('Email: x'),
                _BulletText('Phone: x'),
                _BulletText('Address: x'),

                SizedBox(height: 40),

                _SectionTitle('Mishqat — Privacy Policy'),
                _SubText('Effective Date: 01 June 2025'),

                _SectionHeader('1. Introduction'),
                _BulletText(
                  'We prioritize your privacy. This policy complies with Pakistani data protection laws.',
                ),

                _SectionHeader('2. Information We Collect'),
                _BulletText(
                  'Personal Info: Name, contact, DOB, gender, images, preferences, payments.',
                ),
                _BulletText(
                  'Usage Data: IP, device, browser, timestamps, interaction logs.',
                ),

                _SectionHeader('3. How We Collect Information'),
                _BulletText('Direct input during sign-up and communication.'),
                _BulletText('Automatically through cookies and trackers.'),
                _BulletText(
                  'Via third-party logins (Google, Facebook, Apple).',
                ),

                _SectionHeader('4. Use of Information'),
                _BulletText(
                  'To operate, personalize, secure, and improve the Service.',
                ),
                _BulletText('To match profiles and manage subscriptions.'),
                _BulletText('To send updates and prevent fraud.'),

                _SectionHeader('5. Sharing of Information'),
                _BulletText('We do not sell data. Sharing only occurs with:'),
                _BulletText('• Trusted partners (under NDA)'),
                _BulletText('• Legal obligations'),
                _BulletText('• Mergers/acquisitions'),
                _BulletText('• With your explicit consent'),

                _SectionHeader('6. User Rights & Choices'),
                _BulletText('You can access, edit, or delete your data.'),
                _BulletText('Withdraw consent or manage cookies.'),
                _BulletText('Contact: support@Mishqat.com'),

                _SectionHeader('7. Data Security'),
                _BulletText(
                  'We implement multiple safeguards, though no system is 100% secure.',
                ),

                _SectionHeader('8. Data Retention'),
                _BulletText(
                  'We keep data only as long as necessary, shorter for analytics.',
                ),

                _SectionHeader('9. International Data Transfers'),
                _BulletText(
                  'We ensure legal protection for any international transfers.',
                ),

                _SectionHeader('10. Cookies & Tracking Technologies'),
                _BulletText('Used for experience improvement and analytics.'),

                _SectionHeader('11. Third-Party Links and Services'),
                _BulletText(
                  'We are not responsible for other sites linked through our Service.',
                ),

                _SectionHeader('12. Changes to Privacy Policy'),
                _BulletText(
                  'You will be notified of major changes via the app or email.',
                ),

                _SectionHeader('13. Contact Us'),
                _BulletText('Email: x'),
                _BulletText('Phone: x'),
                _BulletText('Address: x'),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChatPage()),
                    );
                  },
                  child: Text(
                    'Chat',
                    style: GoogleFonts.poppins(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class _SubText extends StatelessWidget {
  final String text;
  const _SubText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 20),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 14, fontStyle: FontStyle.italic),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 10),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _BulletText extends StatelessWidget {
  final String text;
  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(fontSize: 15.2, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
