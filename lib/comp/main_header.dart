import 'package:flutter/material.dart';
import 'package:match_web_app/pages/my_home_page.dart';
import 'package:match_web_app/pages/payment_page.dart';

class MainHeader extends StatelessWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xFFFAF3F0),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.favorite, color: Color(0xFF573746), size: 28),
          Row(
            children: [
              _NavItem(
                text: "Home",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MyHomePage()),
                  );
                },
              ),
              _NavItem(
                text: "Payment Plan",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PaymentPage()),
                ),
              ),
              _NavItem(text: "Viqar's Blog"),
              _NavItem(text: "Contact Us"),
              _NavItem(text: "More", hasDropdown: true),
            ],
          ),
          /* LogInButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SignInPage()),
              );
            },
          ), */
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final bool hasDropdown;

  const _NavItem({required this.text, this.onTap, this.hasDropdown = false});

  @override
  State<_NavItem> createState() => __NavItemState();
}

class __NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      decoration: _hovered ? TextDecoration.underline : null,
                    ),
                  ),
                  if (widget.hasDropdown)
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
