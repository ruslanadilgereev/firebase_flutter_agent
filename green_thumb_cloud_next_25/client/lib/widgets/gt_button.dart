import 'package:flutter/material.dart';

import '../styles.dart';

enum GtButtonStyle { outlined, elevated }

class GtButton extends StatelessWidget {
  const GtButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style = GtButtonStyle.outlined,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final GtButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final buttonStyle =
        style == GtButtonStyle.outlined
            ? AppButtonStyles.outlined
            : AppButtonStyles.elevated;

    return style == GtButtonStyle.outlined
        ? OutlinedButton(onPressed: onPressed, style: buttonStyle, child: child)
        : ElevatedButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: child,
        );
  }
}
