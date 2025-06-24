import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double? size;
  const TitleText({super.key, required this.text, this.size});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback:
          (bounds) => RadialGradient(
            center: Alignment.bottomLeft,
            radius: 2,
            focalRadius: 0,
            colors: [Color(0xFF59B7EC), Color(0xFF9A62E1), Color(0xFFE66CF9)],
          ).createShader(
            Rect.fromLTWH(0, 0, bounds.width * 3, bounds.height * 3),
          ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: size ?? 32,
        ),
      ),
    );
  }
}
