import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../settings/styles.dart';

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

class BodyWhitespace extends StatelessWidget {
  const BodyWhitespace({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(Size.s), child: child);
  }
}

class PageTitle extends StatelessWidget {
  const PageTitle({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(textAlign: TextAlign.center, style: headerStyle, text);
  }
}

class PageSubtitle extends StatelessWidget {
  const PageSubtitle({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Size.m),
      child: Text(style: subheaderStyle, text),
    );
  }
}

class ParagraphText extends StatelessWidget {
  const ParagraphText({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Size.m, vertical: Size.m),
      child: Text(style: paragraphStyle, text),
    );
  }
}
