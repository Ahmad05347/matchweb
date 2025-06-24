// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:match_web_app/comp/my_textfield.dart';
import 'package:match_web_app/comp/sign_button.dart';
import 'package:match_web_app/database/firebase_auth_service.dart';
import 'package:match_web_app/pages/my_home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _signInEmailController = TextEditingController();
  final TextEditingController _signInPasswordController =
      TextEditingController();
  final TextEditingController _signUpNameController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController =
      TextEditingController();

  final FirebaseAuthService _authService = FirebaseAuthService();

  final PageController _pageController = PageController();

  void _goToSignUp() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _goToSignIn() {
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // LEFT SIDE
          Expanded(
            child: Container(
              height: size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6B3F4D),
                    Color(0xFF573746),
                    Color(0xFF3E2A33),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  "SHADI",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
          ),

          // RIGHT SIDE (Sliding content)
          Expanded(
            child: Center(
              child: SizedBox(
                width: 420,
                height: 590,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Sign In
                    AuthCard(
                      title: "Sign In",
                      fields: [
                        MyTextfield(
                          label: "Email Address",
                          controller: _signInEmailController,
                          isName: false,
                        ),
                        const SizedBox(height: 16),
                        MyTextfield(
                          label: "Password",
                          controller: _signInPasswordController,
                          isObscure: true,
                          isName: false,
                        ),
                      ],
                      onTap: () async {
                        try {
                          await _authService.signInWithEmail(
                            _signInEmailController.text,
                            _signInPasswordController.text,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MyHomePage(),
                            ),
                          );
                        } catch (e) {
                          _showErrorDialog(context, e.toString());
                        }
                      },
                      bottomText: "Don't have an account?",
                      bottomAction: "Sign up",
                      onBottomTap: _goToSignUp,
                    ),

                    // Sign Up
                    AuthCard(
                      title: "Create Account",
                      fields: [
                        MyTextfield(
                          label: "Full Name",
                          controller: _signUpNameController,
                          isName: true,
                        ),
                        const SizedBox(height: 16),
                        MyTextfield(
                          label: "Email Address",
                          controller: _signUpEmailController,
                          isName: false,
                        ),
                        const SizedBox(height: 16),
                        MyTextfield(
                          label: "Password",
                          controller: _signUpPasswordController,
                          isObscure: true,
                          isName: false,
                        ),
                      ],
                      onTap: () async {
                        try {
                          await _authService.signUpWithEmail(
                            _signUpEmailController.text,
                            _signUpPasswordController.text,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MyHomePage(),
                            ),
                          );
                        } catch (e) {
                          _showErrorDialog(context, e.toString());
                        }
                      },
                      bottomText: "Already have an account?",
                      bottomAction: "Log in",
                      onBottomTap: _goToSignIn,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Shared form widget for Sign In / Sign Up
class AuthCard extends StatelessWidget {
  final String title;
  final List<Widget> fields;
  final VoidCallback onTap;
  final String bottomText;
  final String bottomAction;
  final VoidCallback onBottomTap;

  const AuthCard({
    super.key,
    required this.title,
    required this.fields,
    required this.onTap,
    required this.bottomText,
    required this.bottomAction,
    required this.onBottomTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            spreadRadius: 2,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 30),
          ...fields,
          const SizedBox(height: 30),
          SignButton(onTap: onTap, text: "Continue"),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(bottomText, style: GoogleFonts.inter(fontSize: 14)),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: onBottomTap,
                child: Text(
                  bottomAction,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFFcd9c9c),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: const [
              Expanded(child: Divider(thickness: 1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("OR"),
              ),
              Expanded(child: Divider(thickness: 1)),
            ],
          ),
          const SizedBox(height: 30),
          InkWell(
            onTap: () {}, // Google sign-in logic
            child: Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "CONTINUE WITH GOOGLE",
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
