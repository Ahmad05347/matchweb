import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:match_web_app/widgets/profile_action_handler.dart';

class HoverProfileCard extends StatefulWidget {
  final Map<String, dynamic> profile;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const HoverProfileCard({
    super.key,
    required this.profile,
    this.onAccept,
    this.onReject,
  });

  @override
  State<HoverProfileCard> createState() => _HoverProfileCardState();
}

class _HoverProfileCardState extends State<HoverProfileCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  void _showExpandedProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: 500,
          height: 550,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: PageView(
                    children: widget.profile['images'] != null
                        ? (widget.profile['images'] as List)
                              .map<Widget>(
                                (img) => ClipOval(
                                  child: Image.asset(
                                    img,
                                    fit: BoxFit.cover,
                                    width: 240,
                                    height: 240,
                                  ),
                                ),
                              )
                              .toList()
                        : [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                widget.profile["image"]!,
                                fit: BoxFit.cover,
                                width: 240,
                                height: 240,
                              ),
                            ),
                          ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    Text(
                      widget.profile["name"],
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${widget.profile["age"]} years • ${widget.profile["city"]}",
                      style: GoogleFonts.inter(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.profile["description"] ??
                          "No description provided.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    // 🔽 Additional Fields Section
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        _infoChip("Height", widget.profile["height"]),
                        _infoChip("Occupation", widget.profile["occupation"]),
                        _infoChip(
                          "Education",
                          widget.profile["educationLevel"],
                        ),
                        _infoChip("Languages", widget.profile["languages"]),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmAction(String title, String message) async {
    return await ProfileActionHandler.showConfirmationDialog(
      context: context,
      title: title,
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => _showExpandedProfile(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 300,
          height: 450,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFFd4c2be), Color(0xFFa28a87)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    widget.profile["image"]!,
                    fit: BoxFit.cover,
                  ),
                ),

                // Blur overlay on hover
                if (_isHovered)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                      child: Container(color: Colors.black.withOpacity(0.2)),
                    ),
                  ),

                // Gradient at the bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 140,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),

                // Profile Info
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.profile["name"],
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${widget.profile["age"]} years • ${widget.profile["city"]}",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      if (_isHovered) ...[
                        const SizedBox(height: 6),
                        Text(
                          widget.profile["description"] ??
                              "Looking for meaningful connections.",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Action Buttons
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  top: _isHovered ? 16 : -60,
                  right: 16,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _isHovered ? 1.0 : 0.0,
                    child: Row(
                      children: [
                        Tooltip(
                          message: "Accept",
                          child: IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                            ),
                            onPressed: () async {
                              final confirm = await _confirmAction(
                                "Accept",
                                "Accept ${widget.profile["name"]}?",
                              );
                              if (confirm) widget.onAccept?.call();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: "Reject",
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () async {
                              final confirm = await _confirmAction(
                                "Reject",
                                "Reject ${widget.profile["name"]}?",
                              );
                              if (confirm) widget.onReject?.call();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoChip(String label, String? value) {
    return Chip(
      backgroundColor: Color.fromARGB(255, 244, 236, 235),
      label: Text(
        "$label: ${value ?? 'N/A'}",
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.transparent),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    );
  }
}
