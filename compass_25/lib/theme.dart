// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  static const primary = primarySeedColor;
  static const red1 = Color(0xFFE74C3C);
  static const grey3 = Color(0xFFA4A4A4);
  static const textGrey = Color(0xFF4D4D4D);
  static const whiteTransparent = Color(0x4DFFFFFF);
  static WidgetStateProperty<Color> primaryColorMaterialState =
      WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
        WidgetState.focused | WidgetState.pressed | WidgetState.hovered:
            AppColors.primary,
        WidgetState.disabled: Colors.grey.shade400,
        WidgetState.any: AppColors.primary,
      });
  static const chatBubbleUser = Color(0xFFE9DFF8);
  static const chatBubbleOther = Color(0xFFEDE7F1);
}

const primarySeedColor = Color(0xFF660091);
const surfaceTintColorValue = Colors.grey;

ThemeData lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    scrolledUnderElevation: 2.0,
    shadowColor: Colors.grey,
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: primarySeedColor,
    brightness: Brightness.light,
    onSurface: Colors.black,
    primaryContainer: Colors.grey.shade400,
  ).copyWith(surface: Colors.white),
  buttonTheme: ButtonThemeData(buttonColor: AppColors.primary),
  primaryColor: primarySeedColor,
  scaffoldBackgroundColor: Colors.white,
  useMaterial3: true,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.rubik(),
    displayMedium: GoogleFonts.rubik(),
    displaySmall: GoogleFonts.rubik(),
    headlineLarge: GoogleFonts.rubik(),
    headlineMedium: GoogleFonts.rubik(),
    headlineSmall: GoogleFonts.rubik(),
    titleLarge: GoogleFonts.rubik(),
    titleMedium: GoogleFonts.rubik(),
    titleSmall: GoogleFonts.rubik(),
    bodyLarge: GoogleFonts.rubik(),
    bodyMedium: GoogleFonts.rubik(),
    bodySmall: GoogleFonts.rubik(),
    labelLarge: GoogleFonts.rubik(),
    labelMedium: GoogleFonts.rubik(),
    labelSmall: GoogleFonts.rubik(),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
  cupertinoOverrideTheme: CupertinoThemeData(
    textTheme: CupertinoTextThemeData(
      textStyle: GoogleFonts.rubik(),
      actionTextStyle: GoogleFonts.rubik(color: primarySeedColor),
      actionSmallTextStyle: GoogleFonts.rubik(
        color: primarySeedColor,
        fontSize: 10,
      ),
      pickerTextStyle: GoogleFonts.rubik(),
      dateTimePickerTextStyle: GoogleFonts.rubik(),
      tabLabelTextStyle: GoogleFonts.rubik(fontSize: 12),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  appBarTheme: AppBarTheme(scrolledUnderElevation: 0.0),
  colorScheme: ColorScheme.fromSeed(
    seedColor: primarySeedColor,
    brightness: Brightness.dark,
  ),
  primaryColor: primarySeedColor,
  useMaterial3: true,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.rubik(color: Colors.white),
    displayMedium: GoogleFonts.rubik(color: Colors.white),
    displaySmall: GoogleFonts.rubik(color: Colors.white),
    headlineLarge: GoogleFonts.rubik(color: Colors.white),
    headlineMedium: GoogleFonts.rubik(color: Colors.white),
    headlineSmall: GoogleFonts.rubik(color: Colors.white),
    titleLarge: GoogleFonts.rubik(color: Colors.white),
    titleMedium: GoogleFonts.rubik(color: Colors.white),
    titleSmall: GoogleFonts.rubik(color: Colors.white),
    bodyLarge: GoogleFonts.rubik(color: Colors.white),
    bodyMedium: GoogleFonts.rubik(color: Colors.white),
    bodySmall: GoogleFonts.rubik(color: Colors.white),
    labelLarge: GoogleFonts.rubik(color: Colors.white),
    labelMedium: GoogleFonts.rubik(color: Colors.white),
    labelSmall: GoogleFonts.rubik(color: Colors.white),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
  cupertinoOverrideTheme: CupertinoThemeData(
    textTheme: CupertinoTextThemeData(
      textStyle: GoogleFonts.rubik(color: Colors.white),
      actionTextStyle: GoogleFonts.rubik(color: primarySeedColor),
      navTitleTextStyle: GoogleFonts.rubik(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      pickerTextStyle: GoogleFonts.rubik(color: Colors.white),
      dateTimePickerTextStyle: GoogleFonts.rubik(color: Colors.white),
    ),
  ),
);
