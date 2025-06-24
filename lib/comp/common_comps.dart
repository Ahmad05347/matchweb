import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

commonText(String text) {
  return Text(
    text,
    style: GoogleFonts.poppins(
      fontSize: 20,
      color: Colors.black87,
      fontWeight: FontWeight.w500,
    ),
  );
}

secondText(String text) {
  return Text(
    text,
    style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87),
  );
}

thirdText(String text) {
  return Text(
    text,
    style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
  );
}

overviewText(String text) {
  return Text(
    text,

    style: TextStyle(
      decoration: TextDecoration.underline,
      fontSize: 13,
      color: Colors.black54,
      fontWeight: FontWeight.w400,
    ),
  );
}
