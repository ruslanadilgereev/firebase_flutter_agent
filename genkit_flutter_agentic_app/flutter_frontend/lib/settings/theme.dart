import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final offWhite = Color.fromARGB(255, 255, 245, 233);
final moreOffWhite = Color.fromARGB(255, 252, 243, 231);
final aquamarine = Color.fromARGB(255, 23, 124, 163);
final orange = Color.fromARGB(255, 223, 91, 3);

final appTheme = ThemeData(
  textTheme: GoogleFonts.caveatTextTheme(),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.white,
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
  ).copyWith(primary: aquamarine, surface: offWhite),
);
