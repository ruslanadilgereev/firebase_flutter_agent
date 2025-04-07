import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './theme.dart';

TextStyle inter16 = GoogleFonts.inter(fontSize: 16);

TextStyle inter16Bold = GoogleFonts.inter(
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

TextStyle userInputStyle28 = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 28,
  color: orange,
);

TextStyle userInputStyle48 = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 48,
  color: orange,
);

TextStyle headerStyle = TextStyle(
  fontFamily: GoogleFonts.caveatBrush().fontFamily,
  color: Color(0xffFFAB5B),
  fontSize: 48,
  fontWeight: FontWeight.bold,
  height: 0,
);

TextStyle subheaderStyle = TextStyle(
  fontFamily: GoogleFonts.caveatBrush().fontFamily,
  fontSize: 32,
  fontWeight: FontWeight.bold,
);

TextStyle paragraphStyle = GoogleFonts.inter(fontSize: 16);

final double heroAppBarHeight = 180.0;

class Spacing {
  static double get xs => 4;
  static double get s => 8;
  static double get m => 16;
  static double get l => 24;
  static double get xl => 32;
  static double get xxl => 36;
}
