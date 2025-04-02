import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colors
class AppColors {
  static const primary = Color(0xFF3B814E);
  static const primaryDark = Color(0xFF30693F);
  static const primaryLight = Color(0xFFB7FCCA);
  static const textPrimary = Colors.black;
  static const textSecondary = Color(0xFF666666);
  static const appBackground = Colors.white;
  static const grey = Colors.grey;
  static const navigationBarBackground = AppColors.appBackground;
}

// Text Styles
class AppTextStyles {
  static TextStyle get title => GoogleFonts.jua(
    fontSize: 32,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    foreground: Paint()..color = AppColors.appBackground,
  );

  static TextStyle get appBarTitle => GoogleFonts.notoSans(
    color: AppColors.appBackground,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get subtitle =>
      GoogleFonts.notoSans(color: AppColors.appBackground, fontSize: 12);

  static TextStyle get breadcrumb =>
      GoogleFonts.notoSans(color: AppColors.textSecondary, fontSize: 14);

  static TextStyle get heading => GoogleFonts.notoSans(
    color: AppColors.textPrimary,
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get subheading =>
      GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.bold);

  static TextStyle get button => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.appBackground,
  );

  static TextStyle get body =>
      GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.bold);

  static TextStyle get actionButton => GoogleFonts.notoSans(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );

  static TextStyle get value =>
      GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w500);
}

// Button Styles
class AppButtonStyles {
  static ButtonStyle get outlined => OutlinedButton.styleFrom(
    disabledForegroundColor: AppColors.grey,
    foregroundColor: AppColors.primaryDark,
    side: const BorderSide(color: AppColors.primaryDark),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  );

  static ButtonStyle get elevated => ElevatedButton.styleFrom(
    disabledBackgroundColor: AppColors.grey,
    backgroundColor: AppColors.primaryDark,
    foregroundColor: AppColors.appBackground,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  );
}

// Layout Constants
class AppLayout {
  static const double appBarHeight = 64;
  static const double navigationBarHeight = 64;
  static const double defaultPadding = 16;
  static const double largePadding = 24;
  static const double extraLargePadding = 32;
  static const double iconSize = 24;
  static const double smallIconSize = 20;
}
