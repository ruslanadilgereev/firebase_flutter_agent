import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyPackingListTitle extends StatelessWidget {
  const MyPackingListTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'My Packing List',
      style: TextStyle(
        fontFamily: GoogleFonts.caveatBrush().fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
